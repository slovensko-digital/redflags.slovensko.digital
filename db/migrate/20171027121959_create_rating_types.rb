class CreateRatingTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :rating_types do |t|
      t.belongs_to :rating_phase, foreign_key: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
