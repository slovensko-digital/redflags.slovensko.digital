require 'net/http'
require 'uri'
require 'json'

class Metais::ProjectDocumentDetectionResultJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid, location_header)
    url = "#{ENV.fetch('API_URL')}#{location_header}"
    response = Net::HTTP.get_response(URI(url))

    handle_response_errors(response)

    body = parse_json(response.body)
    raise RuntimeError.new('Result status is not "Done"') unless body['status'] == 'Done'

    result = body['result']

    Metais::ProjectDocumentDetectionDeleteJob.perform_later(project_uuid)

    Metais::ProjectDataExtractionJob.perform_later(project_uuid, result)
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
end
