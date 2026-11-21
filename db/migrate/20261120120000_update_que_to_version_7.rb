class UpdateQueToVersion7 < ActiveRecord::Migration[8.1]
  # Que 2 works only with its schema version 7. Jobs queued by the old Que (0.x) stay in
  # que_jobs, but Que 2 workers do not run them.
  def up
    Que.migrate!(version: 7)
  end

  def down
    Que.migrate!(version: 3)
  end
end
