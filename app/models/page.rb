class Page < ApplicationRecord
  has_many :revisions

  belongs_to :published_revision, class_name: :Revision, optional: true
  belongs_to :latest_revision, class_name: :Revision, optional: true

  def title
    latest_revision.title.sub(/\ARed Flags:\s*/, '')
  end

  def published?
    published_revision_id.present?
  end

  def synced?
    published_revision_id == latest_revision_id
  end
end
