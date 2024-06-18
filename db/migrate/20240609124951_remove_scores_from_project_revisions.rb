class RemoveScoresFromProjectRevisions < ActiveRecord::Migration[5.1]
  def change
    remove_column :project_revisions, :total_score, :integer
    remove_column :project_revisions, :maximum_score, :integer
    remove_column :project_revisions, :redflags_count, :integer
  end
end
