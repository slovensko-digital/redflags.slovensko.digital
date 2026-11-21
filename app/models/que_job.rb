class QueJob < ApplicationRecord
  # Que 2 has the job stats only per job class, so count the working jobs per queue here.
  JOB_STATS_SQL = <<~SQL
    SELECT queue, count(locks.id) AS count_working
    FROM public.que_jobs
    LEFT JOIN (
      SELECT (classid::bigint << 32) + objid::bigint AS id
      FROM pg_locks
      WHERE locktype = 'advisory'
    ) locks USING (id)
    WHERE finished_at IS NULL AND expired_at IS NULL
    GROUP BY queue
    ORDER BY queue
  SQL

  def self.job_stats
    job_stats = Que.execute(JOB_STATS_SQL)

    stats = job_stats.each_with_object({}) do |stat, result|
      queue_name = stat[:queue].presence || 'default'
      result[queue_name] = {
        working_count: stat[:count_working],
      }
    end

    stats
  end
end
