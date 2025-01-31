class Metais::SyncProjectDocumentsJob < ApplicationJob
  queue_as :metais

  def perform(project_origin, metais_project)
    metais_project.documents.each do |document|
      project_document = Metais::ProjectDocument.find_or_initialize_by(uuid: document.uuid,
                                                                       project_origin: project_origin,
                                                                       origin_type: Metais::OriginType.find_by(name: 'MetaIS'))

      project_document.name = document.latest_version.nazov
      project_document.filename = document.latest_version.filename
      project_document.value = 'https://metais.vicepremier.gov.sk/dms/file/' + document.uuid
      project_document.description = "MetaIS"
      project_document.save!
    end
  end
end
