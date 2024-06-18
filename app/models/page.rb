# == Schema Information
#
# Table name: pages
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published_revision_id :integer
#  latest_revision_id    :integer
#  project_id            :integer          not null
#  page_type             :integer          not null
#
# Foreign Keys
#
#  fk_rails_...  (latest_revision_id => revisions.id)
#  fk_rails_...  (published_revision_id => revisions.id)
#

class Page < ApplicationRecord
  belongs_to :project

  has_many :revisions

  belongs_to :published_revision, class_name: 'Revision', optional: true
  belongs_to :latest_revision, class_name: 'Revision', optional: true

  enum page_type: { preparation: 0, product: 1}

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

  def page_type_label
    case page_type
    when "preparation"
      "Hodnotenie prípravy"
    when "product"
      "Hodnotenie produktu"
    else
      page_type # Or some default value
    end
  end
end
