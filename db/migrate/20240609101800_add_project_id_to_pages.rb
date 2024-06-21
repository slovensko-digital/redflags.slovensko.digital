class AddProjectIdToPages < ActiveRecord::Migration[5.1]

  def up
    add_reference :pages, :project, index: true, foreign_key: true

    Project.find_each do |project|
      if project.page_id.present?
        Page.update(project.page_id, project_id: project.id)
      end
    end
  end

  def down
    remove_reference :pages, :project
  end
end
