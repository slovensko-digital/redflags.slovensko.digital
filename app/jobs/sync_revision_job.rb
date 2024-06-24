class SyncRevisionJob < ApplicationJob
  queue_as :default

  def perform(revision)
    return if revision.raw['category_id'] != ENV.fetch('REDFLAGS_PROJECTS_CATEGORY_ID').to_i

    Revision.transaction do
      revision.phase_revision.load_from_data(revision.raw)
      revision.phase_revision.save!
    end
  end
end
