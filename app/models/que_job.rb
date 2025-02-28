class QueJob < ApplicationRecord
  def self.job_stats
    job_stats = Que.execute(Que::SQL[:job_stats])

    stats = job_stats.each_with_object({}) do |stat, result|
      queue_name = stat['queue'].presence || 'default'
      result[queue_name] = {
        working_count: stat['count_working'],
      }
    end

    stats
  end
end