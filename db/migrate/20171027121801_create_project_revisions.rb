class CreateProjectRevisions < ActiveRecord::Migration[5.1]
  def change
    create_table :project_revisions do |t|
      t.belongs_to :project, foreign_key: true, null: false
      t.belongs_to :revision, foreign_key: true, null: false
      t.string :title, null: false
      t.string :full_name
      t.string :guarantor
      t.string :description
      t.string :budget
      t.string :status

      t.timestamps
    end
  end
end
