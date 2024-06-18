class InitializationOfTopicsToSheetsJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = ['Projekt', 'Platforma', 'Draft prípravy', 'ID prípravy', 'Príprava publikovaná?'].freeze

  def perform(topic_id, found_page)
    sheets_service = GoogleApiService.get_sheets_service
    response_values = fetch_response_values(sheets_service)
    column_indices = get_column_indices(response_values[2])

    values = construct_values(topic_id, found_page)

    update_sheet_cells(sheets_service, column_indices, response_values.count, values)
  end

  private

  def fetch_response_values(sheets_service)
    response = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_ID'], 'A:ZZ')
    response.values
  end

  def get_column_indices(header_row)
    COLUMN_NAMES.map { |name| header_row.index(name) }
  end

  def construct_values(topic_id, found_page)
    title_parametrized = found_page.latest_revision.title.parameterize
    [
      found_page.latest_revision.title,
      "https://platforma.slovensko.digital/t/#{title_parametrized}/#{topic_id}",
      '',
      topic_id.to_s,
      ''
    ]
  end

  def update_sheet_cells(sheets_service, indices, current_row_count, values)
    values.each_with_index do |value, idx|
      range = "Hárok1!#{(indices[idx] + 65).chr}#{current_row_count}"
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [[value]])
      sheets_service.update_spreadsheet_value(ENV['GOOGLE_SHEET_ID'], range, value_range_object, value_input_option: 'USER_ENTERED')
    end
  end
end