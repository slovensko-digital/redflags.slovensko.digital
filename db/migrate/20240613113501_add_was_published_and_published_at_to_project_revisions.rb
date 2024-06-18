class AddWasPublishedAndPublishedAtToProjectRevisions < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :was_published, :boolean, default: false
    add_column :project_revisions, :published_at, :datetime
  end
end
