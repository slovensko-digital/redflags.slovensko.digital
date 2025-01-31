class CreateMetaisProjectEventTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :'metais.project_event_types' do |t|
      t.string :name

      t.timestamps
    end
  end
end
