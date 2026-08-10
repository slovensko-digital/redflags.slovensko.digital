class AddEventTypeRefToMetaisProjectEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :'metais.project_events', :event_type, index: true, foreign_key: { to_table: 'metais.project_event_types' }
  end
end
