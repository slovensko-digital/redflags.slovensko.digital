class AddPublishedToProjectRevisions < ActiveRecord::Migration[5.1]
  def up
    add_column :phase_revisions, :published, :boolean, default: false

    Project.find_each do |project|
      project.phases.find_each do |phase|
        phase.revisions.find_each do |revision|
          revision.update!(published: project.published_revision_id == revision.id)
        end
      end
    end
  end

  def down
    remove_column :phase_revisions, :published
  end
end
