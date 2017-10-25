class Page < ApplicationRecord
  has_many :revisions

  has_one :published_revision, class_name: :Revision
  has_one :latest_revision, class_name: :Revision
end
