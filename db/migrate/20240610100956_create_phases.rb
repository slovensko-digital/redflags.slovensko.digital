class CreatePhases < ActiveRecord::Migration[5.1]
  def change
    create_table :phases do |t|
      t.references :project, index:true, foreign_key: true
      t.references :phase_type, index:true, foreign_key: true
      t.timestamps
    end
  end
end
