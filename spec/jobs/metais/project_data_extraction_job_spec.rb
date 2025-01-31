require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::ProjectDataExtractionJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_uuid) { 'project-123' }
  let(:document_uuid) { 'doc-456' }
  let(:api_url) { 'http://api.example.com' }
  let(:latest_version) do
    double(
      'latest_version',
      filename: 'test.pdf',
      metais_created_at: Time.zone.parse('2023-01-01 12:00:00 UTC')
    )
  end
  let(:document) do
    double(
      'Datahub::Metais::ProjectDocument',
      latest_version: latest_version
    )
  end

  before do
    ENV['API_URL'] = api_url
    allow(Datahub::Metais::ProjectDocument)
      .to receive(:find_by)
      .with(uuid: document_uuid)
      .and_return(document)
  end

  describe '#perform' do
    context 'when the API returns 202 Accepted with Location header' do
      let(:location_header) { 'http://api.example.com/status/123' }

      before do
        stub_request(:post, "#{api_url}/projects/#{project_uuid}?document_uuid=#{document_uuid}")
          .with(
            headers: { 'Content-Type' => 'application/json' },
            body: {
              filename: 'test.pdf',
              created_at: '2023-01-01T12:00:00.000Z'
            }.to_json
          )
          .to_return(
            status: 202,
            headers: { 'Location' => location_header }
          )
      end

      it 'enqueues ProjectDataExtractionStatusJob with location' do
        described_class.perform_now(project_uuid, document_uuid)
        
        expect(Metais::ProjectDataExtractionStatusJob)
          .to have_been_enqueued
          .with(project_uuid, location_header)
      end
    end

    context 'when the API returns non-202 response' do
      before do
        stub_request(:post, /.*/)
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises an error with response details' do
        expect {
          described_class.perform_now(project_uuid, document_uuid)
        }.to raise_error(RuntimeError, /Response status is 500. Message: Internal Server Error/)
      end
    end

    context 'when the API returns 202 without Location header' do
      before do
        stub_request(:post, /.*/)
          .to_return(status: 202)
      end

      it 'raises an error about missing Location header' do
        expect {
          described_class.perform_now(project_uuid, document_uuid)
        }.to raise_error(RuntimeError, /Expected 'Location' header not found/)
      end
    end

    context 'when building the request' do
      let(:location_header) { 'http://api.example.com/status/123' }

      it 'sends correct JSON payload' do
        stub_request(:post, "#{api_url}/projects/#{project_uuid}?document_uuid=#{document_uuid}")
          .with(
            body: {
              filename: 'test.pdf',
              created_at: '2023-01-01T12:00:00.000Z'
            }.to_json
          )
          .to_return(status: 202, headers: { 'Location' => location_header })

        described_class.perform_now(project_uuid, document_uuid)
        
        expect(a_request(:post, /projects/).with(body: hash_including(
          filename: 'test.pdf',
          created_at: '2023-01-01T12:00:00.000Z'
        ))).to have_been_made
      end
    end
  end
end