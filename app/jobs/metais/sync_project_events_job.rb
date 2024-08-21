class Metais::SyncProjectEventsJob < ApplicationJob
  queue_as :metais

  def perform(project_origin, metais_project)
    origin_type = Metais::OriginType.find_by(name: 'MetaIS')
    event_type = Metais::ProjectEventType.find_by(name: 'Realita')
    project_changes = Datahub::Metais::ProjectChange.where(project_version: metais_project.latest_version)

    project_changes.each do |change|
      if change.field == 'status'
        event_date = change.created_at
        event_name = Datahub::Metais::CodelistProjectState.find_by(code: change.new_value)&.nazov || change.new_value
        event_value = "Stav projektu bol zmenený z
        #{Datahub::Metais::CodelistProjectState.find_by(code: change.old_value)&.nazov || change.new_value} na
        #{Datahub::Metais::CodelistProjectState.find_by(code: change.new_value)&.nazov || change.new_value}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   event_type: event_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'faza_projektu'
        event_date = change.created_at
        event_name = Datahub::Metais::CodelistProjectPhase.find_by(code: change.new_value)&.nazov || change.new_value
        event_value = "Fáza projektu bola zmenená z
        #{Datahub::Metais::CodelistProjectPhase.find_by(code: change.old_value)&.nazov || change.old_value} na
        #{Datahub::Metais::CodelistProjectPhase.find_by(code: change.new_value)&.nazov || change.new_value}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   event_type: event_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      end
    end
  end
end
