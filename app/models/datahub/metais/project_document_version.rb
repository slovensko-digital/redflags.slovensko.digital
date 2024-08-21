class Datahub::Metais::ProjectDocumentVersion < DatahubRecord
  self.table_name = "metais.project_document_versions"

  belongs_to :document, class_name: 'Datahub::Metais::ProjectDocument', foreign_key: 'document_id'
end