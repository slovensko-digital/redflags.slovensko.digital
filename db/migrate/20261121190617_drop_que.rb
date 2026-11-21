class DropQue < ActiveRecord::Migration[8.1]
  # GoodJob replaced Que. Drops what Que created in its schema version 7, with the jobs left in the queue.
  def up
    execute <<~SQL
      DROP TABLE IF EXISTS que_jobs, que_lockers, que_values CASCADE;
      DROP FUNCTION IF EXISTS que_validate_tags(jsonb), que_job_notify(), que_state_notify();
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Run Que.migrate!(version: 7) with the version of the app that has Que.'
  end
end
