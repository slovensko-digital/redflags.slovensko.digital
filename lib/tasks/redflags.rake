namespace :redflags do
  task sync: :environment do
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))
  end
end

namespace :metais do
  task daily_sync: :environment do
    Metais::DailySyncProjectsJob.perform_later
  end

  task daily_sync_evaluations: :environment do
    LinkMetaisProjectsAndEvaluationsJob.perform_later
  end
end
