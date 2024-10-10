class Metais::SyncProjectJob < ApplicationJob
  queue_as :metais

  def perform(project, metais_project)
      project_origin = Metais::ProjectOrigin.find_or_initialize_by(project: project,
                                                                   origin_type: Metais::OriginType.find_by(name: 'MetaIS'))

      project_origin.title = metais_project.latest_version.nazov
      project_origin.description = metais_project.latest_version.popis
      project_origin.status = Datahub::Metais::CodelistProjectState.find_by(code: metais_project.latest_version.status)&.nazov || metais_project.latest_version.status
      project_origin.phase = Datahub::Metais::CodelistProjectPhase.find_by(code: metais_project.latest_version.faza_projektu)&.nazov || metais_project.latest_version.faza_projektu
      project_origin.guarantor = metais_project.latest_version.prijimatel

      project_origin.metais_created_at = metais_project.latest_version.metais_created_at
      project_origin.start_date = metais_project.latest_version.datum_zacatia
      project_origin.end_date = metais_project.latest_version.termin_ukoncenia
      project_origin.status_change_date = metais_project.latest_version.zmena_stavu

      project_origin.finance_source = Datahub::Metais::CodelistProgram.find_by(uuid: metais_project.latest_version.program)&.nazov || metais_project.latest_version.program
      project_origin.investment = metais_project.latest_version.suma_vydavkov
      project_origin.operation = metais_project.latest_version.rocne_naklady
      project_origin.approved_investment = metais_project.latest_version.schvaleny_rozpocet
      project_origin.approved_operation = metais_project.latest_version.schvalene_rocne_naklady

      project_origin.save!

      Metais::ProjectDataExtractionJob.set(wait: 5.minutes).perform_later(metais_project.uuid)
      Metais::SyncProjectSuppliersJob.perform_later(project_origin, metais_project)
      Metais::SyncProjectDocumentsJob.perform_later(project_origin, metais_project)
      Metais::SyncProjectEventsJob.perform_later(project_origin, metais_project)
  end
end
