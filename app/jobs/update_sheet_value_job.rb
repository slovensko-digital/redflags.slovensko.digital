class UpdateSheetValueJob < ApplicationJob
  queue_as :default

  REQUIRED_COLUMNS = ['ID prípravy', 'ID produktu'].freeze

  def perform(page_id, column_names, page_type, published_value)
    sheets_service = GoogleApiService.get_sheets_service
    response_values = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_ID'], 'A:Z')&.values

    header_row = response_values[2]
    indices = find_indices(header_row)

    row_index = find_row_index(response_values[3..-1], indices, page_id)
    if row_index.nil?
      raise ArgumentError, "No data found for the given page_id in the spreadsheet. ID may not match or is not in string format."
    end

    match_column_name = column_names[page_type]
    if match_column_name
      handle_row(sheets_service, ENV['GOOGLE_SHEET_ID'], header_row, row_index, match_column_name, published_value)
    else
      raise ArgumentError, "No matching column for page type."
    end
  end

  private

  def find_indices(header_row)
    indices = REQUIRED_COLUMNS.map { |name| [name, header_row.index(name)] }.to_h
    return indices if indices.values.all?

    raise ArgumentError, "Could not find required columns in the spreadsheet."
  end

  def find_row_index(rows, indices, page_id)
    rows.find_index do |row|
      row[indices['ID prípravy']] == page_id.to_s || row[indices['ID produktu']] == page_id.to_s
    end
  end

  def handle_row(sheets_service, google_sheet_id, header_row, row_index, column_name, published_value)
    column_index = header_row.index(column_name)
    raise ArgumentError, "Could not find the provided column in the spreadsheet." if column_index.nil?

    update_google_sheet(sheets_service, google_sheet_id, row_index, column_index, published_value)
  end

  def update_google_sheet(sheets_service, google_sheet_id, row, column_index, value)
    range = "Hárok1!#{(column_index + 65).chr}#{row + 4}"
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [[value]])

    sheets_service.update_spreadsheet_value(google_sheet_id, range, value_range_object, value_input_option: 'USER_ENTERED')
  end
end
