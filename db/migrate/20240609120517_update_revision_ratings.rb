class UpdateRevisionRatings < ActiveRecord::Migration[5.1]
  def change
    remove_reference :revision_ratings, :project_revision, index: true, foreign_key: true
    add_reference :revision_ratings, :revision, index: true, foreign_key: true
  end
end
