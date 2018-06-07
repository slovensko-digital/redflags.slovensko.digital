# == Schema Information
#
# Table name: project_stages
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :project_stage do
    name 'Reformný zámer'
  end
end
