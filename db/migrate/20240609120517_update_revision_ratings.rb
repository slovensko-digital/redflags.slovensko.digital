class UpdateRevisionRatings < ActiveRecord::Migration[5.1]
  def up
    add_reference :revision_ratings, :revision, index: true, foreign_key: true

    RevisionRating.reset_column_information
    RevisionRating.find_each do |revision_rating|
      project_revision = ProjectRevision.find(revision_rating.project_revision_id)
      revision_rating.update!(revision_id: project_revision.revision_id)
    end

    remove_reference :revision_ratings, :project_revision, index: true, foreign_key: true
  end

  def down
    remove_reference :revision_ratings, :revision, index: true, foreign_key: true
    add_reference :revision_ratings, :project_revision, index: true, foreign_key: true
  end
end
