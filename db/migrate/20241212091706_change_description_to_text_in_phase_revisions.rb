class ChangeDescriptionToTextInPhaseRevisions < ActiveRecord::Migration[5.1]
  def change
    change_column :phase_revisions, :description, :text
  end
end
