namespace :redflags do
  task sync: :environment do
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))
  end
end
