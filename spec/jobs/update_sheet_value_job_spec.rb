require 'rails_helper'

RSpec.describe UpdateSheetValueJob, type: :job do
  include ActiveJob::TestHelper

  let(:page_id) { 'Prod1' }
  let(:column_names) { { 'topic' => 'ID prípravy', 'product' => 'ID produktu' } }
  let(:page_type) { 'product' }
  let(:published_value) { 'DraftProd1' }
  let(:response_values) do
    OpenStruct.new(values: [
      [],
      [],
      ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'],
      ['Projekt1', 'ABC1', '', 'ABC1', 'ABC1', 'ABC1', 'ABC1'],
      ['Projekt2', 'ABC2', 'http://google.com', 'ABC2', 'ABC2', 'ABC2', 'ABC2']
    ])
  end
  let(:header_row) { response_values.values[2] }
  let(:indices) { { 'ID prípravy' => 4, 'ID produktu' => 6 } }
  let(:sheets_service) { instance_double(Google::Apis::SheetsV4::SheetsService) }

  before do
    allow(GoogleApiService).to receive(:get_sheets_service).and_return(sheets_service)
    allow(sheets_service).to receive(:get_spreadsheet_values).with(ENV['GOOGLE_SHEET_ID'], 'A:Z').and_return(response_values)
    allow_any_instance_of(UpdateSheetValueJob).to receive(:find_indices).and_return(indices)
    allow_any_instance_of(UpdateSheetValueJob).to receive(:find_row_index).and_return(0)
    allow(sheets_service).to receive(:update_spreadsheet_value)
  end

  context 'when performing the job' do
    let(:instance) { described_class.new }

    before do
      allow(UpdateSheetValueJob).to receive(:new).and_return(instance)
      allow(instance).to receive(:find_indices).and_call_original
      allow(instance).to receive(:find_row_index).and_return(3)
    end

    it 'fetches spreadsheet values, finds indices, finds row, handles row and updates sheet' do
      instance.perform(page_id, column_names, page_type, published_value)

      expect(GoogleApiService).to have_received(:get_sheets_service)
      expect(sheets_service).to have_received(:get_spreadsheet_values).with(ENV['GOOGLE_SHEET_ID'], 'A:Z')
      expect(instance).to have_received(:find_indices).with(header_row)
      expect(instance).to have_received(:find_row_index).with(response_values.values[3..-1], indices, page_id)
      expect(sheets_service).to have_received(:update_spreadsheet_value)
    end
  end

  context 'when no matching column for page type' do
    let(:column_names) { {} }

    it 'raises an ArgumentError' do
      expect { described_class.perform_now(page_id, column_names, page_type, published_value) }.to raise_error(ArgumentError, "No matching column for page type.")
    end
  end

  context 'when no matching row for page id' do
    let(:page_id) { 'nonexistent' }

    before do
      allow_any_instance_of(UpdateSheetValueJob).to receive(:find_row_index).and_return(nil)
    end

    it 'raises an ArgumentError' do
      expect { described_class.perform_now(page_id, column_names, page_type, published_value) }.to raise_error(ArgumentError, "No data found for the given page_id in the spreadsheet. ID may not match or is not in string format.")
    end
  end
end