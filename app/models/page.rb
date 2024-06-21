# == Schema Information
#
# Table name: pages
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published_revision_id :integer
#  latest_revision_id    :integer
#
# Foreign Keys
#
#  fk_rails_...  (latest_revision_id => revisions.id)
#  fk_rails_...  (published_revision_id => revisions.id)
#

class Page < ApplicationRecord
  belongs_to :phase

  has_many :revisions

  belongs_to :published_revision, class_name: 'Revision', optional: true
  belongs_to :latest_revision, class_name: 'Revision', optional: true

  delegate :title, to: :latest_revision

  def publishable?
    true
  end

  def published?
    published_revision.present?
  end

  def synced?
    published_revision == latest_revision
  end
end
