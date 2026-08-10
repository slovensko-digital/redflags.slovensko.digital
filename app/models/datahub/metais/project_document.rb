class Datahub::Metais::ProjectDocument < DatahubRecord
  self.table_name = "metais.project_documents"

  belongs_to :project, class_name: 'Datahub::Metais::Project', foreign_key: 'project_id'
  has_many :versions, class_name: 'Datahub::Metais::ProjectDocumentVersion'
  belongs_to :latest_version, class_name: 'Datahub::Metais::ProjectDocumentVersion', foreign_key: 'latest_version_id', optional: true
end