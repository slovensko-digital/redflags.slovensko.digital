class AddScoresToRevisions < ActiveRecord::Migration[5.1]
  def up
    add_column :revisions, :total_score, :integer
    add_column :revisions, :maximum_score, :integer
    add_column :revisions, :redflags_count, :integer, default: 0

    ProjectRevision.find_each do |proj_revision|
      revision = Revision.find(proj_revision.revision_id)
      revision.update!(
        total_score: proj_revision.total_score,
        maximum_score: proj_revision.maximum_score,
        redflags_count: proj_revision.redflags_count
      )
    end
  end

  def down
    remove_column :revisions, :total_score
    remove_column :revisions, :maximum_score
    remove_column :revisions, :redflags_count
  end
end
