require_relative 'environment'

Rails.application.load_tasks

module Clockwork
  configure do |config|
    config[:thread] = true
  end

  handler do |job|
    Rake::Task[job].reenable
    Rake::Task[job].invoke
  end

  every(1.day, 'redflags:sync_google_drafts', at: '3:00')
  every(1.day, 'redflags:sync_sheets', at: '5:00')
end
