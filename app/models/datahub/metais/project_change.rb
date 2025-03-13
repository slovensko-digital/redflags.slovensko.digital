class Datahub::Metais::ProjectChange < DatahubRecord
  self.table_name = "metais.project_changes"

  belongs_to :project_version, class_name: 'Datahub::Metais::ProjectVersion'
end