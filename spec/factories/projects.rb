# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  page_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_projects_on_page_id  (page_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#

FactoryBot.define do
  factory :project do
    page nil
  end
end
