class AddWasPublishedAndPublishedAtToProjectRevisions < ActiveRecord::Migration[5.1]
  def up
    add_column :phase_revisions, :was_published, :boolean, default: false
    add_column :phase_revisions, :published_at, :datetime

    Phase.find_each do |phase|
      if phase.published_revision.present?
        published_revision = phase.published_revision
        published_revision.update_attributes!(was_published: true, published_at: published_revision.revision.updated_at)
      end
    end
  end

  def down
    remove_column :phase_revisions, :was_published
    remove_column :phase_revisions, :published_at
  end
end
