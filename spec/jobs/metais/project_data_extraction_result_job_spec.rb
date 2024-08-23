require 'rails_helper'
require 'net/http'

RSpec.describe Metais::ProjectDataExtractionResultJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_uuid) { 'sample-uuid' }
  let(:location_header) { 'http://example.com/location' }
  let(:api_url) { 'http://example.com/api' }
  let(:url) { "#{api_url}/projects/#{project_uuid}" }

  let(:response) { instance_double('Net::HTTPResponse') }
  let(:body) { { 'status' => 'Done', 'result' => result_data }.to_json }
  let(:result_data) do
    {
      'harmonogram' => [],
      'responsible' => { 'first_name' => 'John', 'surname' => 'Doe' },
      'capex' => 1000,
      'opex' => 500,
      'declared' => 200,
      'kpis' => ['KPI 1', 'KPI 2'],
      'goals' => ['Goal 1', 'Goal 2']
    }
  end
  let(:metais_project) { instance_double('Metais::Project') }
  let(:project_origin) { instance_double('Metais::ProjectOrigin') }
  let(:origin_type) { instance_double('Metais::OriginType') }
  let(:event_type) { instance_double('Metais::ProjectEventType') }

  let(:project_origins_double) { double('ProjectOrigins') }

  before do
    allow(ENV).to receive(:fetch).with('API_URL').and_return(api_url)
  end

  describe '#perform' do
    before do
      allow(Net::HTTP).to receive(:get_response).and_return(response)
    end

    context 'when the response is successful and the project exists' do
      before do
        allow(response).to receive(:code).and_return('200')
        allow(response).to receive(:body).and_return(body)
        allow(JSON).to receive(:parse).and_return('status' => 'Done', 'result' => result_data)

        allow(Metais::Project).to receive(:find_by).with(uuid: project_uuid).and_return(metais_project)

        allow(metais_project).to receive(:project_origins).and_return(project_origins_double)

        allow(project_origins_double).to receive(:first).and_return(double('FirstProjectOrigin', title: 'Origin Title'))
        allow(project_origins_double).to receive(:find_or_initialize_by).with(
          title: 'Origin Title',
          project: metais_project,
          origin_type: origin_type
        ).and_return(project_origin)

        allow(project_origin).to receive(:project_manager=)
        allow(project_origin).to receive(:approved_investment=)
        allow(project_origin).to receive(:approved_operation=)
        allow(project_origin).to receive(:benefits=)
        allow(project_origin).to receive(:targets_text=)
        allow(project_origin).to receive(:save!)

        allow(Metais::OriginType).to receive(:find_by).with(name: 'AI').and_return(origin_type)

        allow(Metais::ProjectEventType).to receive(:find_by).with(name: 'Predpoklad').and_return(event_type)

        allow(Metais::ProjectEvent).to receive(:find_or_initialize_by).and_return(double('Metais::ProjectEvent', save!: true))

        allow(Net::HTTP).to receive(:start).and_return(double('Net::HTTPResponse', is_a?: true, code: '200'))
      end

      it 'successfully processes the result and sends a delete request' do
        expect {
          described_class.perform_now(project_uuid, location_header)
        }.not_to have_enqueued_job

        expect(Net::HTTP).to have_received(:start)
      end
    end

    context 'when the response status is not 200 or 202' do
      before do
        allow(response).to receive(:code).and_return('500')
        allow(response).to receive(:body).and_return('Internal Server Error')
      end

      it 'raises a RuntimeError with the correct message' do
        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Unexpected response status: 500, body: Internal Server Error/)
      end
    end

    context 'when JSON parsing fails' do
      before do
        allow(response).to receive(:code).and_return('200')
        allow(response).to receive(:body).and_return('invalid json')
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError.new('error'))
      end

      it 'raises a RuntimeError with the correct message' do
        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Failed to parse JSON response: error/)
      end
    end

    context 'when project cannot be found' do
      before do
        allow(response).to receive(:code).and_return('200')
        allow(response).to receive(:body).and_return(body)
        allow(JSON).to receive(:parse).and_return('status' => 'Done', 'result' => {})
        allow(Metais::Project).to receive(:find_by).with(uuid: project_uuid).and_return(nil)
      end

      it 'raises a RuntimeError indicating the project was not found' do
        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Couldn't find MetaIS project with 'uuid'=sample-uuid/)
      end
    end

    context 'when project origin cannot be found or saved' do
      before do
        allow(response).to receive(:code).and_return('200')
        allow(response).to receive(:body).and_return(body)
        allow(JSON).to receive(:parse).and_return('status' => 'Done', 'result' => result_data)

        allow(project_origins_double).to receive(:find_or_initialize_by).and_return(nil)
      end

      it 'raises an error when the project origin cannot be found or initialized' do
        expect {
          described_class.perform_now(project_uuid, location_header)
        }.to raise_error(RuntimeError, /Couldn't find MetaIS project with 'uuid'=sample-uuid/)
      end
    end
  end
end
