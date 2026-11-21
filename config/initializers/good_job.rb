Rails.application.configure do
  # Jobs run in threads of the web server, there is no worker or clock process. Rails console, rake tasks
  # and migrations only enqueue the jobs.
  config.good_job.execution_mode = :async
  # One job at a time as with the former worker (que -w1). The jobs call Google APIs with low limits and
  # the export to the sheet looks for the row of a project before it adds one.
  config.good_job.threads = 1

  # The times of the former clock, in the time zone of the system.
  config.good_job.enable_cron = true
  config.good_job.cron = {
    sync_google_drafts: {
      cron: '0 3 * * *',
      class: 'SyncAllTopicsJob',
      kwargs: { sync_all: false },
      description: 'Imports the drafts of the ratings from Google Docs, as rake redflags:sync_google_drafts.'
    },
    sync_sheets: {
      cron: '0 5 * * *',
      class: 'SyncSheetsProjectInfoJob',
      description: 'Writes what is published to the Google sheets, as rake redflags:sync_sheets.'
    }
  }
end

# The dashboard of the jobs is for the admins only.
GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(username, ENV.fetch('ADMIN_USER')) &
    ActiveSupport::SecurityUtils.secure_compare(password, ENV.fetch('ADMIN_PASSWORD'))
end
