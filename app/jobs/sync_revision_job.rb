class SyncRevisionJob < ApplicationJob
  queue_as :default

  def perform(revision)
    return if revision.raw['category_id'] != ENV.fetch('REDFLAGS_PROJECTS_CATEGORY_ID').to_i

    Phase.transaction do
      page = revision.page
      phase = page.phase

      phase_revision = phase.revisions.find_or_initialize_by(revision_id: revision.id)
      phase_revision.load_from_data(revision.raw)
      phase_revision.save!
    end
  end
end
