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
end
