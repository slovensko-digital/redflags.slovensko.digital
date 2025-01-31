require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::ProjectDocumentDetectionJob, type: :job do
  let(:project_uuid) { 'test-uuid-123' }
  let(:project) { instance_double(Metais::Project, uuid: project_uuid) }
  let(:documents) { [{ title: 'Test Document' }] }
  let(:api_url) { 'http://api.example.com' }

  before do
    ENV['API_URL'] = api_url
    allow(Metais::Project).to receive(:find_by).with(uuid: project_uuid).and_return(project)
    allow(project).to receive(:get_project_documents).and_return(documents)
  end

  describe '#perform' do
    context 'when the API responds with 202 Accepted and Location header' do
      let(:location_header) { 'http://api.example.com/status/123' }

      before do
        stub_request(:post, "#{api_url}/projects/#{project_uuid}/documents")
          .with(
            body: { documents: documents }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(
            status: 202,
            headers: { 'Location' => location_header },
            body: '{}'
          )
      end

      it 'enqueues the ProjectDocumentDetectionStatusJob with the location' do
        expect {
          described_class.perform_now(project_uuid)
        }.to have_enqueued_job(Metais::ProjectDocumentDetectionStatusJob)
          .with(project_uuid, location_header)
      end
    end

    context 'when the API responds with a non-202 status' do
      before do
        stub_request(:post, "#{api_url}/projects/#{project_uuid}/documents")
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises an error with the response details' do
        expect {
          described_class.perform_now(project_uuid)
        }.to raise_error(RuntimeError, /Response status is 500. Message: Internal Server Error/)
      end
    end

    context 'when the API responds with 202 but no Location header' do
      before do
        stub_request(:post, "#{api_url}/projects/#{project_uuid}/documents")
          .to_return(status: 202, body: '{}')
      end

      it 'raises an error about the missing Location header' do
        expect {
          described_class.perform_now(project_uuid)
        }.to raise_error(RuntimeError, /Expected 'Location' header not found/)
      end
    end
  end
end