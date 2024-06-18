class SyncRevisionJob < ApplicationJob
  queue_as :default

  def perform(revision)
    Project.transaction do
      page = revision.page
      project = page.project

      project_revision = project.revisions.find_or_initialize_by(revision_id: revision.id)
      project_revision.load_from_data(revision.raw)
      project_revision.save!
    end
  end
end
