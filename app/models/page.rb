class Page < ApplicationRecord
  has_many :revisions

  belongs_to :published_revision, class_name: :Revision, optional: true
  belongs_to :latest_revision, class_name: :Revision, optional: true

  delegate :title, to: :latest_revision

  def published?
    published_revision.present?
  end

  def synced?
    published_revision == latest_revision
  end
end
