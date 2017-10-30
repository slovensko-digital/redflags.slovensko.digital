# == Schema Information
#
# Table name: rating_phases
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :rating_phase do
    name "MyString"
  end
end
