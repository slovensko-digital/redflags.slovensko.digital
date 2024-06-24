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

FactoryBot.define do
  factory :project do
  end
end
