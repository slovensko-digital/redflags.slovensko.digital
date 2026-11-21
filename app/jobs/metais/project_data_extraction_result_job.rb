require 'net/http'
require 'uri'
require 'json'

class Metais::ProjectDataExtractionResultJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid, location_header)
    url = "#{ENV.fetch('API_URL')}#{location_header}"
    response = Net::HTTP.get_response(URI(url))

    handle_response_errors(response)

    body = parse_json(response.body)
    raise RuntimeError.new('Result status is not "Done"') unless body['status'] == 'Done'

    result = body['result']
    result = parse_json(result) if result.is_a?(String)

    unless ['No documents', 'No documents for project plan'].include? result['detail']
      metais_project = find_metais_project(project_uuid)
      project_origin = find_or_initialize_project_origin(metais_project)

      update_project_origin(project_origin, result)
      process_harmonogram(result['harmonogram'], project_origin)
    end

    Metais::ProjectDataExtractionDeleteJob.perform_later(project_uuid)
  end

  private

  def handle_response_errors(response)
    case response.code.to_i
    when 200, 202
    else
      error_message = "Unexpected response status: #{response.code}, body: #{response.body}"
      raise RuntimeError, error_message
    end
  end

  def parse_json(body)
    JSON.parse(body)
  rescue JSON::ParserError => e
    error_message = "Failed to parse JSON response: #{e.message}"
    raise RuntimeError, error_message
  end

  def find_metais_project(project_uuid)
    Metais::Project.find_by(uuid: project_uuid).tap do |project|
      unless project
        error_message = "Couldn't find MetaIS project with 'uuid'=#{project_uuid}"
        raise RuntimeError, error_message
      end
    end
  end

  def find_or_initialize_project_origin(metais_project)
    metais_project.project_origins.find_or_initialize_by(title: metais_project.project_origins.first.title,
                                                         project: metais_project,
                                                         origin_type: Metais::OriginType.find_by(name: 'AI'))
  end

  def update_project_origin(project_origin, result)
    project_origin.project_manager = "#{result['responsible']['first_name']} #{result['responsible']['surname']}"
    project_origin.approved_investment = result['capex'].to_i unless result['capex'].to_i.zero?
    project_origin.approved_operation = result['opex'].to_i unless result['opex'].to_i.zero?
    project_origin.benefits = result['declared'].to_i unless result['declared'].to_i.zero?
    project_origin.targets_text = format_targets_text(result) unless format_targets_text(result).empty?
    project_origin.save!
  end

  def format_targets_text(result)
    kpis = Array(result['kpis']).join("\n") unless result['kpis'].to_s.empty?
    goals = Array(result['goals']).join("\n") unless result['goals'].to_s.empty?
    [kpis, goals].compact.join("\n")
  end

  def process_harmonogram(harmonogram, project_origin)
    origin_type = Metais::OriginType.find_by(name: 'AI')
    event_type = Metais::ProjectEventType.find_by(name: 'Predpoklad')

    harmonogram.each do |event_data|
      event_start_date = event_data['start_date'] || 'N/A'
      event_end_date = event_data['end_date'] || 'N/A'
      event_date = parse_event_date(event_data['start_date'])
      event_name = event_data['item_name'] unless event_data['item_name'].empty?
      event_value = "Projektu bude v stave #{event_data['item_name'].downcase} od #{event_start_date} do #{event_end_date}"

      project_event = Metais::ProjectEvent.find_or_initialize_by(
        project_origin: project_origin,
        origin_type: origin_type,
        event_type: event_type,
        name: event_name,
        value: event_value,
        date: event_date
      )

      unless project_event.save
        error_message = "Error encountered while creating an event: #{project_event.errors.full_messages.to_sentence}"
        raise RuntimeError, error_message
      end
    end
  end

  def parse_event_date(start_date)
    return if start_date.blank?
    Date.strptime(start_date, "%m/%Y")
  rescue ArgumentError => e
    raise RuntimeError, e
  end
end
