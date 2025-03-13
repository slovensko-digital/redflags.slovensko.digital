namespace :metais do
  task daily_sync: :environment do
    Metais::DailySyncProjectsJob.perform_later
  end

  task daily_sync_evaluations: :environment do
    LinkMetaisProjectsAndEvaluationsJob.perform_later
  end

  task init_sync: :environment do
    Metais::InitialSyncProjectsJob.perform_later
  end

  task pair_older_projects: :environment do
    SetMetaisCodesForProjectsJob.perform_later
  end
end
