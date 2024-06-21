class UpdatePhaseRevisionsTable < ActiveRecord::Migration[5.1]
  def change
    remove_reference :phase_revisions, :project, index: true, foreign_key: true
    add_reference :phase_revisions, :phase, index: true, foreign_key: true
  end
end
