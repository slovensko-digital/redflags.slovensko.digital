class AddPublishedRevisionToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :published_revision, foreign_key: { to_table: :project_revisions }
  end
end
