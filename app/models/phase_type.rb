# == Schema Information
#
# Table name: phase_types
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PhaseType < ApplicationRecord
end
