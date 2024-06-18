class AddPublishedToProjectRevisions < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :published, :boolean, default: false
  end
end
