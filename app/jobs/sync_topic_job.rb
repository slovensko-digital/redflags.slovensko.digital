class SyncTopicJob < ApplicationJob
  queue_as :default

  def perform(project_id, topic_id)
    client = DiscourseApi::Client.new(ENV.fetch('REDFLAGS_DISCOURSE_URL'))
    topic = client.topic(topic_id)
    project = nil

    Page.transaction do
      page = Page.find_or_create_by!(id: topic_id) do |new_page|
        #new_project = Project.find_or_create_by(id: project_id)
        project = Project.find_by(id: project_id) || Project.create
        new_page.project = project if project.persisted?
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
      #InitializationOfTopicsToSheetsJob.set(wait: 15.seconds).perform_later(topic_id, page, project)
    end
  end
end
