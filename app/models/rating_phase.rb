# == Schema Information
#
# Table name: rating_phases
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RatingPhase < ApplicationRecord
  has_many :rating_types
end
