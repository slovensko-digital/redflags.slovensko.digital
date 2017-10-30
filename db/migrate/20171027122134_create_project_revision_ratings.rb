class CreateProjectRevisionRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :project_revision_ratings do |t|
      t.belongs_to :project_revision, foreign_key: true, null: false
      t.belongs_to :rating_type, foreign_key: true, null: false
      t.integer :score

      t.timestamps
    end
  end
end
