class SyncTopicJob < ApplicationJob
  queue_as :default

  def perform(project_id, topic_id)
    client = DiscourseApi::Client.new(ENV.fetch('REDFLAGS_DISCOURSE_URL'))
    topic = client.topic(topic_id)
    page = nil
    project = nil

    Page.transaction do
      page = Page.find_or_create_by!(id: topic_id) do |new_page|
        project = Project.find_or_create_by(id: new_page.latest_revision&.phase_revision&.phase&.project&.id || project_id)
        phase_type = PhaseType.find_by(name: 'Prípravná fáza')
        new_phase = Phase.find_or_create_by(project: project, phase_type: phase_type)
        new_page.phase = new_phase
        new_page.save!
      end

      project ||= Project.find_by(id: page.latest_revision&.phase_revision&.phase&.project&.id || project_id || page.id)

      version = topic['post_stream']['posts'].first['version']

      revision = page.revisions.find_or_initialize_by(version: version)
      revision.title = topic['title']
      revision.tags = topic['tags']
      revision.raw = topic
      revision.save!

      page.latest_revision = revision
      page.save!
    end

    # For initial import of current topics into Google Sheets
    InitializationOfTopicsToSheetsJob.set(wait: 30.seconds).perform_later(topic_id, page, project)
  end
end
