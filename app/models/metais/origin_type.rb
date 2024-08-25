# == Schema Information
#
# Table name: metais.origin_types
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::OriginType < ApplicationRecord
end
