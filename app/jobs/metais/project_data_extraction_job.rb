require 'net/http'
require 'uri'

class Metais::ProjectDataExtractionJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid, document_uuid)
    document = Datahub::Metais::ProjectDocument.find_by(uuid: document_uuid)

    url = "#{ENV.fetch('API_URL')}/projects/#{project_uuid}"
    uri = URI.parse(url)
    uri.query = URI.encode_www_form({ document_uuid: document_uuid })
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
    request.body = { filename: document.latest_version.filename, created_at: document.latest_version.metais_created_at }.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPAccepted)
      error_message = "Response status is #{response.code}. Message: #{response.body}"
      raise RuntimeError, error_message
    end

    location = response['Location']
    if location.nil?
      error_message = "Expected 'Location' header not found in the response."
      raise RuntimeError, error_message
    end

    Metais::ProjectDataExtractionStatusJob.perform_later(project_uuid, location)
  end
end
