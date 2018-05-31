class AddProjectStageToProjectRevisions < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_revisions, :stage, foreign_key: { to_table: :project_stages }
    remove_column :project_revisions, :status
  end
end
