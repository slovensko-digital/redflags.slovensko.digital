class AddAggregatedScoreToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :project_revisions, :total_score, :integer
    add_column :project_revisions, :maximum_score, :integer
  end
end
