class AddPublishedToProjectRevisions < ActiveRecord::Migration[5.1]
  def up
    add_column :project_revisions, :published, :boolean, default: false

    Project.find_each do |project|
      project.revisions.find_each do |revision|
        if project.published_revision_id == revision.id
          revision.update_attribute(:published, true)
        else
          revision.update_attribute(:published, false)
        end
      end
    end
  end

  def down
    remove_column :project_revisions, :published
  end
end
