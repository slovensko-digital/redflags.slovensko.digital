class RenameProjectRevisionToPhaseRevisionInPhaseRevisionRatings < ActiveRecord::Migration[5.1]
  def change
    rename_column :phase_revision_ratings, :project_revision_id, :phase_revision_id
  end
end
