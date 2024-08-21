class CreateCombinedProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :combined_projects do |t|
      t.references :metais_project, null: false, index: true, foreign_key: { to_table: 'metais.projects' }
      t.references :evaluation, null: true, index: true, foreign_key: { to_table: 'projects' }

      t.timestamps
    end
  end
end
