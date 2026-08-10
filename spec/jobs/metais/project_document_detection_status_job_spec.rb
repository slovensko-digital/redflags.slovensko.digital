require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::ProjectDocumentDetectionStatusJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_uuid) { 'project-123' }
  let(:location_header) { '/document_detection/status' }
  let(:api_url) { 'http://example.com' }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
    WebMock.disable_net_connect!
  end

  after do
    WebMock.allow_net_connect!
  end

  describe '#perform' do
    context 'when the response includes a Retry-After header' do
      it 'reschedules the job with the specified delay' do
        retry_after_seconds = 5
        stub_request(:get, "#{api_url}#{location_header}")
          .to_return(headers: { 'Retry-After' => retry_after_seconds.to_s })

        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to have_enqueued_job(described_class)
          .with(project_uuid, location_header)
          .on_queue(:metais_data_extraction)
          .at(a_value_within(1.second).of(retry_after_seconds.seconds.from_now))
      end
    end

    context 'when the response includes a Location header' do
      let(:result_location) { "#{api_url}/document_detection/result" }

      it 'enqueues the ProjectDocumentDetectionResultJob with the new location' do
        stub_request(:get, "#{api_url}#{location_header}")
          .to_return(headers: { 'Location' => result_location })

        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to have_enqueued_job(Metais::ProjectDocumentDetectionResultJob)
          .with(project_uuid, result_location)
          .on_queue(:metais_data_extraction)
      end
    end

    context 'when the response has no Location header' do
      it 'raises an error' do
        stub_request(:get, "#{api_url}#{location_header}")
          .to_return(headers: {})

        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error('Location header missing in response')
      end
    end
  end
end