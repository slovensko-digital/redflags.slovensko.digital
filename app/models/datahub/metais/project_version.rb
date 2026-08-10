class Datahub::Metais::ProjectVersion < DatahubRecord
  self.table_name = "metais.project_versions"

  belongs_to :project, class_name: 'Datahub::Metais::Project', foreign_key: 'project_id'
end