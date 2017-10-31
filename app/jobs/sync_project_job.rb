class SyncProjectJob < ApplicationJob
  queue_as :default

  def perform(page)
    project = Project.where(page: page).first
    return unless project
    published_project_revision = page.published_revision ? project.revisions.find_by(revision: page.published_revision) : nil
    project.published_revision = published_project_revision
    project.save!
  end
end
