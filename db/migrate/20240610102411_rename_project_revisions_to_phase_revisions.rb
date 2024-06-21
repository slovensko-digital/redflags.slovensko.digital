class RenameProjectRevisionsToPhaseRevisions < ActiveRecord::Migration[5.1]
  def change
    rename_table :project_revisions, :phase_revisions
  end
end
