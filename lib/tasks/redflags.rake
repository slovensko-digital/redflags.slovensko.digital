namespace :redflags do
  task sync: :environment do
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))
  end

  task sync_google_drafts: :environment do
    SyncAllTopicsJob.perform_later(sync_all: false)
  end

  task sync_sheets: :environment do
    SyncSheetsProjectInfoJob.perform_later
  end
end
