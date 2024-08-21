class Metais::SyncProjectEventsJob < ApplicationJob
  queue_as :metais

  def perform(project_origin, metais_project)
    origin_type = Metais::OriginType.find_by(name: 'MetaIS')
    project_changes = Datahub::Metais::ProjectChange.where(project_version: metais_project.latest_version)

    project_changes.each do |change|
      if change.field == 'status'
        event_date = change.created_at
        event_name = 'Zmena stavu projektu'
        event_value = "Stav projektu bol zmenený z
        #{Datahub::Metais::CodelistProjectState.find_by(code: change.old_value)&.nazov || change.new_value} na
        #{Datahub::Metais::CodelistProjectState.find_by(code: change.new_value)&.nazov || change.new_value}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'zmena_stavu'
        event_date = change.created_at
        event_name = 'Zmena dátumu pre stav projektu'
        event_value = "Dátum pre stav projektu bol zmenený z
        #{change.old_value.present? ? "#{DateTime.parse(change.old_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"} na
        #{change.new_value.present? ? "#{DateTime.parse(change.new_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value, date: event_date)
        project_event.save!
      elsif change.field == 'nazov'
        event_date = change.created_at
        event_name = 'Zmena názvu projektu'
        event_value = "Názov projektu bol zmenený z #{change.old_value} na #{change.new_value}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value, date: event_date)
        project_event.save!

      elsif change.field == 'faza_projektu'
        event_date = change.created_at
        event_name = 'Zmena fázy projektu'
        event_value = "Fáza projektu bola zmenená z
        #{Datahub::Metais::CodelistProjectPhase.find_by(code: change.old_value)&.nazov || change.old_value} na
        #{Datahub::Metais::CodelistProjectPhase.find_by(code: change.new_value)&.nazov || change.new_value}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!
      elsif change.field == 'program'
        event_date = change.created_at
        event_name = 'Zmena zdroja financovania projektu'
        event_value = "Zdroj financovania projektu bol zmenený z
        #{Datahub::Metais::CodelistProgram.find_by(uuid: change.old_value)&.nazov || change.old_value} na
        #{Datahub::Metais::CodelistProgram.find_by(uuid: change.new_value)&.nazov || change.new_value}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!
      elsif change.field == 'schvalene_rocne_naklady'
        event_date = change.created_at
        event_name = 'Zmena schválených ročných nákladov projektu'
        event_value = "Schválené ročné náklady projektu boli zmenené z
        #{change.old_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.old_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"} na
        #{change.new_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.new_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'schvaleny_rozpocet'
        event_date = change.created_at
        event_name = 'Zmena schváleného rozpočtu projektu'
        event_value = "Schválený rozpočet projektu bol zmenený z
        #{change.old_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.old_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"} na
        #{change.new_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.new_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'suma_vydavkov'
        event_date = change.created_at
        event_name = 'Zmena rozpočtu projektu'
        event_value = "Rozpočet projektu bol zmenený z
        #{change.old_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.old_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"} na
        #{change.new_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.new_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'rocne_naklady'
        event_date = change.created_at
        event_name = 'Zmena ročných nákladov projektu'
        event_value = "Ročné náklady projektu boli zmenené z
        #{change.old_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.old_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"} na
        #{change.new_value.to_s.empty? ? 'N/A' : "#{number_to_currency(change.new_value.to_f, unit: '€',  separator: ',', delimiter: ' ', format: '%n %u')}"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'datum_zacatia'
        event_date = change.created_at
        event_name = 'Zmena dátumu začatia projektu'
        event_value = "Dátum začatia projektu bol zmenený z
        #{change.old_value.present? ? "#{DateTime.parse(change.old_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"} na
        #{change.new_value.present? ? "#{DateTime.parse(change.new_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'termin_ukoncenia'
        event_date = change.created_at
        event_name = 'Zmena termínu ukončenia projektu'
        event_value = "Termín ukončenia projektu bol zmenený z
        #{change.old_value.present? ? "#{DateTime.parse(change.old_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"} na
        #{change.new_value.present? ? "#{DateTime.parse(change.new_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'prijimatel'
        event_date = change.created_at
        event_name = 'Zmena gestora projektu'
        event_value = "Gestor projektu bol zmenený z #{change.old_value.present?? change.old_value : 'N/A'} na #{change.new_value.present?? change.new_value : 'N/A'}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'datum_nfp'
        event_date = change.created_at
        event_name = 'Zmena dátumu NFP projektu'
        event_value = "Dátum NFP projektu bol zmenený z
        #{change.old_value.present? ? "#{DateTime.parse(change.old_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"} na
        #{change.new_value.present? ? "#{DateTime.parse(change.new_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'link_nfp'
        event_date = change.created_at
        event_name = 'Zmena NFP projektu'
        event_value = "NFP projektu bolo zmenené z #{change.old_value.present?? change.old_value : 'N/A'} na #{change.new_value.present?? change.new_value : 'N/A'}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'zmluva_o_dielo'
        event_date = change.created_at
        event_name = 'Zmena dátumu CRZ projektu'
        event_value = "Dátum CRZ projektu bol zmenený z
        #{change.old_value.present? ? "#{DateTime.parse(change.old_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"} na
        #{change.new_value.present? ? "#{DateTime.parse(change.new_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'zmluva_o_dielo_crz'
        event_date = change.created_at
        event_name = 'Zmena CRZ projektu'
        event_value = "CRZ projektu bolo zmenené z #{change.old_value.present?? change.old_value : 'N/A'} na #{change.new_value.present?? change.new_value : 'N/A'}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'vyhlasenie_vo'
        event_date = change.created_at
        event_name = 'Zmena dátumu VO projektu'
        event_value = "Dátum VO projektu bol zmenený z
        #{change.old_value.present? ? "#{DateTime.parse(change.old_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"} na
        #{change.new_value.present? ? "#{DateTime.parse(change.new_value).in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')}" : "N/A"}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!

      elsif change.field == 'vo'
        event_date = change.created_at
        event_name = 'Zmena VO projektu'
        event_value = "VO projektu bolo zmenené z #{change.old_value.present?? change.old_value : 'N/A'} na #{change.new_value.present?? change.new_value : 'N/A'}"

        project_event = Metais::ProjectEvent.find_or_initialize_by(project_origin: project_origin,
                                                                   origin_type: origin_type,
                                                                   name: event_name,
                                                                   value: event_value,
                                                                   date: event_date)
        project_event.save!
      end
    end
  end
end
