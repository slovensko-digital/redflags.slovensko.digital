# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  page_id               :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published_revision_id :integer
#  category              :integer          default("boring"), not null
#
# Indexes
#
#  index_projects_on_page_id                (page_id)
#  index_projects_on_published_revision_id  (published_revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#  fk_rails_...  (published_revision_id => project_revisions.id)
#

class Project < ApplicationRecord
  belongs_to :page

  has_many :revisions, class_name: 'ProjectRevision'

  belongs_to :published_revision, class_name: 'ProjectRevision', optional: true

  scope :published, -> { where('published_revision_id IS NOT NULL') }
  scope :with_tag, -> (tag) { joins(published_revision: :revision).where(":tags = ANY(revisions.tags)", tags: tag) }

  enum category: { good: 0, bad: 1, boring: 2 }
end
