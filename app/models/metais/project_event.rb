# == Schema Information
#
# Table name: metais.project_events
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  value                 :string           not null
#  date                  :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::ProjectEvent < ApplicationRecord
  belongs_to :project_origin, class_name: 'Metais::ProjectOrigin'
  belongs_to :origin_type, class_name: 'Metais::OriginType'
  belongs_to :event_type, class_name: 'Metais::ProjectEventType'
end
