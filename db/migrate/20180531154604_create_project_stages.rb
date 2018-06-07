class CreateProjectStages < ActiveRecord::Migration[5.1]
  def change
    create_table :project_stages do |t|
      t.string :name, null: false
      t.integer :position
      t.timestamps
    end
  end
end
