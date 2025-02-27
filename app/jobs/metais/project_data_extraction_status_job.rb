class Metais::ProjectDataExtractionStatusJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid, location_header)
    url = "#{ENV.fetch('API_URL')}#{location_header}"
    response = Net::HTTP.get_response(URI(url))

    if response.key?('Retry-After')
      Metais::ProjectDataExtractionStatusJob.set(wait: response['Retry-After'].to_i.seconds).perform_later(project_uuid, location_header)
    else
      location = response['Location']
      raise "Location header missing in response" unless location

      Metais::ProjectDataExtractionResultJob.perform_later(project_uuid, location)
    end
  end
end
