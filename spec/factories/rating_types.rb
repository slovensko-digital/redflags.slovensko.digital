# == Schema Information
#
# Table name: rating_types
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
#

FactoryBot.define do
  factory :rating_type do
  end
end
