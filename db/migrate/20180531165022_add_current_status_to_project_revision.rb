class AddCurrentStatusToProjectRevision < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :current_status, :string
  end
end
