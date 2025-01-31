require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::ProjectDocumentDetectionDeleteJob, type: :job do
  let(:project_uuid) { 'test-project-uuid' }
  let(:api_url) { 'http://api.example.com' }
  let(:expected_url) { "#{api_url}/projects/#{project_uuid}/documents" }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
  end

  describe '#perform' do
    context 'when the API request succeeds' do
      before do
        stub_request(:delete, expected_url)
          .to_return(status: 200, body: '')
      end

      it 'sends a DELETE request to the correct endpoint' do
        described_class.new.perform(project_uuid)
        expect(a_request(:delete, expected_url)).to have_been_made.once
      end

      it 'does not raise an error' do
        expect {
          described_class.new.perform(project_uuid)
        }.not_to raise_error
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:delete, expected_url)
          .to_return(status: 500, body: 'Server Exploded')
      end

      it 'raises an error with the response details' do
        expect {
          described_class.new.perform(project_uuid)
        }.to raise_error(RuntimeError, /Failed to delete project: 500, body: Server Exploded/)
      end
    end
  end

  describe 'queue configuration' do
    it 'uses the correct queue' do
      expect(described_class.new.queue_name).to eq('metais_data_extraction')
    end
  end
end