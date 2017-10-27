class Page < ApplicationRecord
  has_many :revisions

  has_one :published_revision, class_name: :Revision
  has_one :latest_revision, class_name: :Revision

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
