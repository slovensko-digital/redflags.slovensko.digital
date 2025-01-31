require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::ProjectDocumentDetectionResultJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_uuid) { 'project-123' }
  let(:location_header) { '/document-detection/result' }
  let(:api_url) { 'http://api.example.com/' }
  let(:full_url) { "#{api_url}#{location_header}" }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
    WebMock.reset!
  end

  describe '#perform' do
    context 'when HTTP response is unsuccessful' do
      it 'raises an error for non-200/202 status codes' do
        stub_request(:get, full_url).to_return(status: 500, body: 'Server Error')

        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Unexpected response status: 500/)
      end
    end

    context 'when response contains invalid JSON' do
      it 'raises a JSON parsing error' do
        stub_request(:get, full_url).to_return(status: 200, body: 'invalid json')

        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Failed to parse JSON response/)
      end
    end

    context 'when status is not "Done"' do
      it 'raises an error' do
        stub_request(:get, full_url)
          .to_return(status: 200, body: { status: 'Processing' }.to_json)

        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Result status is not "Done"/)
      end
    end

    context 'when status is "Done"' do
      let(:result) { { key: 'value' } }

      context 'with 200 OK response' do
        before do
          stub_request(:get, full_url)
            .to_return(status: 200, body: { status: 'Done', result: result }.to_json)
        end

        it 'enqueues ProjectDocumentDetectionDeleteJob' do
          expect {
            described_class.perform_now(project_uuid, location_header)
          }.to have_enqueued_job(Metais::ProjectDocumentDetectionDeleteJob)
            .with(project_uuid)
        end

        it 'enqueues ProjectDataExtractionJob with result' do
          expect {
            described_class.perform_now(project_uuid, location_header)
          }.to have_enqueued_job(Metais::ProjectDataExtractionJob)
            .with(project_uuid, a_hash_including('key' => 'value'))
            .on_queue('metais_data_extraction')
        end
      end

      context 'with 202 Accepted response' do
        before do
          stub_request(:get, full_url)
            .to_return(status: 202, body: { status: 'Done', result: result }.to_json)
        end

        it 'still processes the result and enqueues jobs' do
          expect {
            described_class.perform_now(project_uuid, location_header)
          }.to have_enqueued_job(Metais::ProjectDocumentDetectionDeleteJob)
            .and have_enqueued_job(Metais::ProjectDataExtractionJob)
        end
      end
    end
  end
end