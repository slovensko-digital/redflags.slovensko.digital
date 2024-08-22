require 'net/http'
require 'uri'

class Metais::ProjectDataExtractionJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid)
    url = "#{ENV.fetch('API_URL')}/projects/#{project_uuid}"
    response = Net::HTTP.post(URI(url), '')

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
