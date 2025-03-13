require 'net/http'
require 'uri'

class Metais::ProjectDataExtractionDeleteJob < ApplicationJob
  queue_as :metais_data_extraction

  def perform(project_uuid)
    url = "#{ENV.fetch('API_URL')}/projects/#{project_uuid}"
    uri = URI(url)

    req = Net::HTTP::Delete.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    unless res.is_a?(Net::HTTPSuccess)
      error_message = "Failed to delete project: #{res.code}, body: #{res.body}"
      raise RuntimeError, error_message
    end
  end
end
