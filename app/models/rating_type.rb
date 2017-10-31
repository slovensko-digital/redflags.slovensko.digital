# == Schema Information
#
# Table name: rating_types
#
#  id              :integer          not null, primary key
#  rating_phase_id :integer          not null
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_rating_types_on_rating_phase_id  (rating_phase_id)
#
# Foreign Keys
#
#  fk_rails_...  (rating_phase_id => rating_phases.id)
#

class RatingType < ApplicationRecord
  belongs_to :rating_phase
end
