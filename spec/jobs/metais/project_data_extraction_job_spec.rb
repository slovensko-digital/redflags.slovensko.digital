require 'rails_helper'
require 'net/http'

RSpec.describe Metais::ProjectDataExtractionJob, type: :job do
  let(:project_uuid) { 'sample-uuid' }
  let(:api_url) { 'http://example.com/api' }
  let(:url) { "#{api_url}/projects/#{project_uuid}" }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
  end

  describe '#perform' do
    let(:response) { instance_double(Net::HTTPResponse) }

    before do
      allow(Net::HTTP).to receive(:post).and_return(response)
    end

    context 'when the response status is 202 Accepted' do
      before do
        allow(response).to receive(:is_a?).with(Net::HTTPAccepted).and_return(true)
        allow(response).to receive(:[]).with('Location').and_return('http://example.com/location')
      end

      it 'enqueues the Metais::ProjectDataExtractionStatusJob with the correct parameters' do
        expect(Metais::ProjectDataExtractionStatusJob).to receive(:perform_later).with(project_uuid, 'http://example.com/location')
        subject.perform(project_uuid)
      end
    end

    context 'when the response status is not 202 Accepted' do
      before do
        allow(response).to receive(:is_a?).with(Net::HTTPAccepted).and_return(false)
        allow(response).to receive(:code).and_return('400')
        allow(response).to receive(:body).and_return('Bad Request')
      end

      it 'raises a RuntimeError with the appropriate message' do
        expect {
          subject.perform(project_uuid)
        }.to raise_error(RuntimeError, /Response status is 400. Message: Bad Request/)
      end
    end

    context 'when the Location header is missing' do
      before do
        allow(response).to receive(:is_a?).with(Net::HTTPAccepted).and_return(true)
        allow(response).to receive(:[]).with('Location').and_return(nil)
      end

      it 'raises a RuntimeError indicating the missing Location header' do
        expect {
          subject.perform(project_uuid)
        }.to raise_error(RuntimeError, /Expected 'Location' header not found in the response./)
      end
    end
  end
end
