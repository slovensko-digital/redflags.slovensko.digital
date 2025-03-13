require 'rails_helper'
require 'net/http'

RSpec.describe Metais::ProjectDataExtractionDeleteJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_uuid) { 'sample-uuid' }
  let(:api_url) { 'http://example.com/api' }
  let(:url) { "#{api_url}/projects/#{project_uuid}" }
  let(:uri) { URI(url) }
  let(:response) { instance_double('Net::HTTPResponse') }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
    allow(Net::HTTP).to receive(:start).and_return(response)
  end

  describe '#perform' do
    context 'when the delete request is successful' do
      before do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      end

      it 'sends a delete request' do
        expect {
          described_class.perform_now(project_uuid)
        }.not_to raise_error

        expect(Net::HTTP).to have_received(:start).with(uri.hostname, uri.port, use_ssl: uri.scheme == 'https')
      end
    end

    context 'when the delete request fails' do
      before do
        allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        allow(response).to receive(:code).and_return('500')
        allow(response).to receive(:body).and_return('Internal Server Error')
      end

      it 'raises a RuntimeError with the correct message' do
        expect {
          described_class.perform_now(project_uuid)
        }.to raise_error(RuntimeError, /Failed to delete project: 500, body: Internal Server Error/)
      end
    end
  end
end
