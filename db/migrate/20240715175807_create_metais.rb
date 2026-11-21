class CreateMetais < ActiveRecord::Migration[5.1]
  def up
    execute 'CREATE SCHEMA metais'

    create_table 'metais.projects' do |t|
      t.string :code, null: false
      t.timestamps
    end
  end

  def down
    execute 'DROP SCHEMA metais CASCADE'
  end
end
