class CreateRatingPhases < ActiveRecord::Migration[5.1]
  def change
    create_table :rating_phases do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
