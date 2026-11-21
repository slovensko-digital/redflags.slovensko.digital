class Datahub::Metais::Project < DatahubRecord
  self.table_name = "metais.projects"

  has_many :documents, class_name: 'Datahub::Metais::ProjectDocument', foreign_key: 'project_id'
  has_many :versions, class_name: 'Datahub::Metais::ProjectVersion', foreign_key: 'project_id'
  belongs_to :latest_version, class_name: 'Datahub::Metais::ProjectVersion', foreign_key: 'latest_version_id', optional: true
end