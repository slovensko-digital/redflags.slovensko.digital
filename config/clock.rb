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

  every(1.day, 'redflags:sync', at: '9:00')

  every(1.day, 'metais:daily_sync', at: '10:00')
  every(1.day, 'metais:daily_sync_evaluations', at: '11:00')
end
