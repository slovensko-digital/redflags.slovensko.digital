require 'rails_helper'
require 'net/http'

RSpec.describe Metais::ProjectDataExtractionStatusJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_uuid) { 'sample-uuid' }
  let(:location_header) { 'http://example.com/location' }
  let(:api_url) { 'http://example.com/api' }
  let(:url) { "#{api_url}/projects/#{project_uuid}/status" }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
  end

  describe '#perform' do
    let(:response) { instance_double(Net::HTTPResponse) }

    before do
      allow(Net::HTTP).to receive(:get_response).and_return(response)
    end

    context 'when Retry-After header is present' do
      before do
        allow(response).to receive(:key?).with('Retry-After').and_return(true)
        allow(response).to receive(:[]).with('Retry-After').and_return('10')
      end

      it 're-enqueues the job with a delay' do
        Metais::ProjectDataExtractionStatusJob.perform_now(project_uuid, location_header)

        expect(enqueued_jobs).to include(
                                   a_hash_including(
                                     job: Metais::ProjectDataExtractionStatusJob,
                                     args: [project_uuid, location_header],
                                     queue: 'metais_data_extraction'
                                   )
                                 )
      end
    end

    context 'when Retry-After header is not present' do
      before do
        allow(response).to receive(:key?).with('Retry-After').and_return(false)
        allow(response).to receive(:[]).with('Location').and_return('http://example.com/new_location')
      end

      it 'enqueues the Metais::ProjectDataExtractionResultJob with the correct parameters' do
        expect {
          subject.perform(project_uuid, location_header)
        }.to have_enqueued_job(Metais::ProjectDataExtractionResultJob).with(project_uuid, 'http://example.com/new_location')
      end

      context 'when Location header is missing' do
        before do
          allow(response).to receive(:key?).with('Retry-After').and_return(false)
          allow(response).to receive(:[]).with('Location').and_return(nil)
        end

        it 'raises an error indicating the missing Location header' do
          expect {
            subject.perform(project_uuid, location_header)
          }.to raise_error(RuntimeError, /Location header missing in response/)
        end
      end
    end
  end
end
