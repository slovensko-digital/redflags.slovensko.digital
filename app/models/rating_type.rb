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
#

class RatingType < ApplicationRecord
end
