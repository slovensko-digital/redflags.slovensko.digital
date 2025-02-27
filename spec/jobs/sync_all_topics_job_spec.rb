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
      ['Projekt2', 'ABC2', '', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
    ]
  end

  let(:indices) { { 'Projekt' => 0, 'Projekt ID' => 1, 'Platforma' => 2, 'ID draft prípravy' => 3, 'ID prípravy' => 4, 'ID draft produktu' => 5, 'ID produktu' => 6 } }

  before do
    mock_document = instance_double("Google::Apis::DocsV1::Document")
    allow(mock_document).to receive(:title).and_return("Dokument RF-priprava-template")
    allow(GoogleApiService).to receive(:get_document).and_return(mock_document)
    google_sheets_service = instance_double(Google::Apis::SheetsV4::SheetsService)
    allow(GoogleApiService).to receive(:get_sheets_service).and_return(google_sheets_service)
    allow(google_sheets_service).to receive(:get_spreadsheet_values).with(ENV.fetch('GOOGLE_SHEET_ID'), 'A:Z').and_return(OpenStruct.new(values: response_values))
    allow(mock_document).to receive(:body)
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
                        .on_queue("default")
  end

  it 'executes perform' do
    expect(SyncGoogleDocumentJob).to receive(:perform_now).exactly(4).times

    described_class.perform_now
  end

  context 'when mandatory columns are missing' do
    let(:response_values) do
      [
        [],
        [],
        ['Projekt'],
        ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'],
        ['Projekt2', 'ABC2', 'Platforma link', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
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
        ['Projekt2', 'ABC2', 'Platforma link', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
      ]
    end

    it 'enqueues SyncGoogleDocumentJob' do
      expect(SyncGoogleDocumentJob).to receive(:perform_now).exactly(3).times

      described_class.perform_now
    end
  end
end
