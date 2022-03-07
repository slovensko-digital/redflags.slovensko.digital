class DropRatingPhases < ActiveRecord::Migration[5.1]
  def change
    remove_column :rating_types, :rating_phase_id
    drop_table :rating_phases
  end
end
