class AddNullToProjectInProjectsMetaisProjects < ActiveRecord::Migration[5.1]
  def change
    change_column_null :projects_metais_projects, :project_id, true
  end
end
