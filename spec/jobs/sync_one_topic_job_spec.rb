require 'rails_helper'

RSpec.describe SyncOneTopicJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(page_id) }

  let(:page_id) { 'ABC1' }
  let(:response_values) do
    [
      [],
      [],
      ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'],
      ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'],
      ['Projekt2', 'ABC2', 'http://google.com', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
    ]
  end

  let(:row) { ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'] }

  let(:indices) { { 'Projekt' => 0, 'Projekt ID' => 1, 'Platforma' => 2, 'ID draft prípravy' => 3, 'ID prípravy' => 4, 'ID draft produktu' => 5, 'ID produktu' => 6 } }

  before do
    google_sheets_service = instance_double(Google::Apis::SheetsV4::SheetsService)
    allow(GoogleApiService).to receive(:get_sheets_service).and_return(google_sheets_service)
    mock_document = instance_double("Google::Apis::DocsV1::Document")
    allow(mock_document).to receive(:title).and_return("Dokument RF-priprava-template")
    allow(GoogleApiService).to receive(:get_document).and_return(mock_document)
    allow(google_sheets_service).to receive(:get_spreadsheet_values).with(ENV.fetch('GOOGLE_SHEET_ID'), 'A:Z').and_return(OpenStruct.new(values: response_values))
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
                        .on_queue("default")
                        .with(page_id)
  end

  it 'executes perform' do
    expect(SyncGoogleDocumentJob).to receive(:perform_now)
    described_class.perform_now(page_id)
  end

  context 'when performing the job' do
    it 'fetches spreadsheet values, finds indices and processes row' do
      expect_any_instance_of(SyncOneTopicJob).to receive(:find_indices).with(OpenStruct.new(values: response_values).values[2]).and_return(indices)
      expect_any_instance_of(SyncOneTopicJob).to receive(:process_row).with(row, indices, page_id)

      described_class.perform_now(page_id)
    end
  end

  context 'when no row matches the given page_id' do
    let(:page_id) { 'Prod2' }

    it 'does not attempt to process the row' do
      expect_any_instance_of(SyncOneTopicJob).not_to receive(:process_row)

      described_class.perform_now(page_id)
    end
  end

  context 'when mandatory columns are missing' do
    let(:response_values) do
      [
        ['Projekt'],
        ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'],
        ['Projekt2', 'ABC2', 'http://google.com', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
      ]
    end

    it 'raises an ArgumentError' do
      expect { described_class.perform_now(page_id) }
        .to raise_error(ArgumentError, "Could not find required columns in the spreadsheet.")
    end
  end
end