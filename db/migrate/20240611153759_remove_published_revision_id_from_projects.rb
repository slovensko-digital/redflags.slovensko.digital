class RemovePublishedRevisionIdFromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :published_revision_id
  end
end
