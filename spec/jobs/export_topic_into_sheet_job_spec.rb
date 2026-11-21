require 'rails_helper'

RSpec.describe ExportTopicIntoSheetJob, type: :job do
  let(:sheets_service) { instance_double(Google::Apis::SheetsV4::SheetsService) }
  let(:project) { create(:project) }
  let(:phase) { create(:phase, project: project, phase_type: create(:phase_type, name: 'Prípravná fáza')) }
  let(:page) { create(:page, :published, phase: phase) }
  let(:phase_revision) { page.published_revision.phase_revision }
  let(:header_rows) { [[], ['Info o projekte'], described_class::COLUMN_NAMES] }
  let(:other_project_row) { ['Iný projekt', '1'] }

  before do
    phase_revision.update!(phase: phase, published: true)
    allow(GoogleApiService).to receive(:get_sheets_service).and_return(sheets_service)
    allow(sheets_service).to receive(:get_spreadsheet_values).and_return(Google::Apis::SheetsV4::ValueRange.new(values: sheet_values))
    allow(sheets_service).to receive(:update_spreadsheet_value)
    allow(sheets_service).to receive(:append_spreadsheet_value)
  end

  context 'with the project in the sheet' do
    let(:sheet_values) { header_rows + [other_project_row, ['IS Obchodného registra', project.id.to_s]] }

    it 'updates the row of the project' do
      described_class.perform_now(phase_revision)

      expect(sheets_service).to have_received(:update_spreadsheet_value)
        .with(anything, 'Hárok1!A5:BV5', having_attributes(values: [including('Red Flags: IS Obchodného registra', project.id)]), value_input_option: 'USER_ENTERED')
      expect(sheets_service).not_to have_received(:append_spreadsheet_value)
    end
  end

  context 'without the project in the sheet' do
    let(:sheet_values) { header_rows + [other_project_row] }

    it 'appends a row for the project, so the sheet gets a new row' do
      described_class.perform_now(phase_revision)

      expect(sheets_service).to have_received(:append_spreadsheet_value)
        .with(anything, 'Hárok1!A:BV', having_attributes(values: [including('Red Flags: IS Obchodného registra', project.id)]), value_input_option: 'USER_ENTERED', insert_data_option: 'INSERT_ROWS')
      expect(sheets_service).not_to have_received(:update_spreadsheet_value)
    end
  end
end
