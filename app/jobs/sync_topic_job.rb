class SyncTopicJob < ApplicationJob
  queue_as :default

  def perform(project_id, topic_id)
    client = DiscourseApi::Client.new(ENV.fetch('REDFLAGS_DISCOURSE_URL'))
    topic = client.topic(topic_id)

    Page.transaction do

      page = Page.find_or_create_by!(id: topic_id) do |new_page|
        new_project = Project.find_or_initialize_by(id: project_id)
        new_page.project = new_project if new_project.persisted?
      end

      version = topic['post_stream']['posts'].first['version']

      revision = page.revisions.find_or_initialize_by(version: version)
      revision.title = topic['title']
      revision.tags = topic['tags']
      revision.raw = topic
      revision.load_ratings(topic)
      revision.save!

      page.latest_revision = revision
      page.page_type = 'preparation'
      page.save!

      # For initial import of current topics into Google Sheets
      # InitializationOfTopicsToSheetsJob.perform_later(topic_id, page)
    end
  end
end
