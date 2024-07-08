class SyncSheetsProjectInfoJob < ApplicationJob
  queue_as :default

  def perform
    pages = Page.all.select{ |page| page.phase.present? }

    pages.each do |page|
      if page.published?
        updates = page.build_publish_updates(page.published_revision.phase_revision)
        UpdateMultipleSheetColumnsJob.set(wait: 15.seconds).perform_later(page.id, updates)
        ExportTopicIntoSheetJob.set(wait: 15.seconds).perform_later(page.published_revision.phase_revision)
      else
        updates = page.build_unpublish_updates
        UpdateMultipleSheetColumnsJob.set(wait: 15.seconds).perform_later(page.id, updates)
      end
    end
  end
end
