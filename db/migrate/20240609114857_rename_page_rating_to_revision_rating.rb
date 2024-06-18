class RenamePageRatingToRevisionRating < ActiveRecord::Migration[5.1]
  def change
    rename_table :project_revision_ratings, :revision_ratings
  end
end
