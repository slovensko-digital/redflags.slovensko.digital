class Metais::ProjectEventType < ApplicationRecord
  has_many :project_events, class_name: 'Metais::ProjectEvent'
end
