require 'net/http'
require 'uri'

class Metais::ProjectDocumentDetectionJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid)
    project = Metais::Project.find_by(uuid: project_uuid)
    documents = project.get_project_documents

    url = "#{ENV.fetch('API_URL')}/projects/#{project_uuid}/documents"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    request.body = { documents: documents }.to_json

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

    Metais::ProjectDocumentDetectionStatusJob.perform_later(project_uuid, location)
  end
end
