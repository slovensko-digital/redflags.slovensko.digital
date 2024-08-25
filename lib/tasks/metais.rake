namespace :metais do
  task daily_sync: :environment do
    Metais::DailySyncProjectsJob.perform_later
  end

  task daily_sync_evaluations: :environment do
    LinkMetaisProjectsAndEvaluationsJob.perform_later
  end
end