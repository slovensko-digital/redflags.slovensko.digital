class Metais::ProjectEventType < ApplicationRecord
  self.table_name = "metais.project_event_types"

  has_many :project_events, class_name: 'Metais::ProjectEvent'
end
