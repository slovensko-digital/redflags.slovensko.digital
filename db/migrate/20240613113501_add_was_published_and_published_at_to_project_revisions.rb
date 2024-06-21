class AddWasPublishedAndPublishedAtToProjectRevisions < ActiveRecord::Migration[5.1]
  def up
    add_column :phase_revisions, :was_published, :boolean, default: false
    add_column :phase_revisions, :published_at, :datetime

    Project.find_each do |project|
      project.published_revisions.each do |revision|
        revision.update_attributes(was_published: true, published_at: revision.updated_at)
      end
    end
  end

  def down
    remove_column :phase_revisions, :was_published
    remove_column :phase_revisions, :published_at
  end
end
