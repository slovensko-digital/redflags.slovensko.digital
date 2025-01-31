class CreateJoinTableProjectsMetaisProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects_metais_projects, id: false do |t|
      t.references :project, index: true, foreign_key: {to_table: 'projects'}
      t.references :metais_project, index: true, foreign_key: {to_table: 'metais.projects'}
    end
  end
end
