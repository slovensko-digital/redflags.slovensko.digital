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
# Indexes
#
#  index_pages_on_latest_revision_id     (latest_revision_id)
#  index_pages_on_published_revision_id  (published_revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (latest_revision_id => revisions.id)
#  fk_rails_...  (published_revision_id => revisions.id)
#

class Page < ApplicationRecord
  has_many :revisions
end
