require 'rails_helper'

RSpec.describe SyncAllTopicsJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later }

  let(:sheets_service) { instance_double('GoogleApiService') }
  let(:response_values) do
    [
      [],
      [],
      ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'],
      ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'],
      ['Projekt2', 'ABC2', 'http://google.com', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
    ]
  end

  let(:indices) { { 'Projekt' => 0, 'Projekt ID' => 1, 'Platforma' => 2, 'ID draft prípravy' => 3, 'ID prípravy' => 4, 'ID draft produktu' => 5, 'ID produktu' => 6 } }

  before do
    allow(Google::Auth::ServiceAccountCredentials).to receive(:make_creds).and_return(instance_double(Google::Auth::ServiceAccountCredentials))
    google_sheets_service = instance_double(Google::Apis::SheetsV4::SheetsService)
    allow(GoogleApiService).to receive(:get_sheets_service).and_return(google_sheets_service)
    allow(google_sheets_service).to receive(:get_spreadsheet_values).with(ENV.fetch('GOOGLE_SHEET_ID'), 'A:Z').and_return(OpenStruct.new(values: response_values))
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
                        .on_queue("default")
  end

  it 'executes perform' do
    described_class.perform_now
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 4
  end

  context 'when mandatory columns are missing' do
    let(:response_values) do
      [
        [],
        [],
        ['Projekt'],
        ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'],
        ['Projekt2', 'ABC2', 'http://google.com', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
      ]
    end

    it 'raises an ArgumentError' do
      expect { described_class.perform_now }
        .to raise_error(ArgumentError, "Could not find required columns in the spreadsheet.")
    end
  end

  context 'when spreadsheet values are missing' do
    let(:response_values) do
      [
        [],
        [],
        ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu']
      ]
    end

    it 'does not enqueue any jobs' do
      described_class.perform_now
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 0
    end
  end

  context 'when Platforma is empty for any project' do
    let(:response_values) do
      [
        [],
        [],
        ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'],
        ['Projekt1', 'ABC1', '', 'ABC1', '', 'ABC1', ''],
        ['Projekt2', 'ABC2', 'http://google.com', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
      ]
    end

    it 'enqueues SyncGoogleDocumentJob' do
      described_class.perform_now
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.map { |j| j[:job] }).to include(SyncGoogleDocumentJob)
    end
  end
end
