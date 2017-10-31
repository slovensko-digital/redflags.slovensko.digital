class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.belongs_to :page, foreign_key: true, null: false

      t.timestamps
    end
  end
end
