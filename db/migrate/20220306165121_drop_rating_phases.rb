class DropRatingPhases < ActiveRecord::Migration[5.1]
  def change
    remove_index :rating_types, :index_rating_types_on_rating_phase_id
    remove_foreign_key :rating_types, :rating_phases
    remove_column :rating_types, :rating_phase_id
    
    drop_table :rating_phases
  end
end
