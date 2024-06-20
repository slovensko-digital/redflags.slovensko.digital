class InitializationOfTopicsToSheetsJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = ['Projekt', 'Projekt ID', 'Platforma', 'Draft prípravy', 'ID draft prípravy', 'ID prípravy', 'Príprava publikovaná?', 'Dátum publikácie prípravy', 'RF web príprava'].freeze

  def perform(topic_id, found_page, project)
    uri = URI(ENV['GOOGLE_SHEET_SCRIPT_URL'])
    Net::HTTP.get(uri)

    sheets_service = GoogleApiService.get_sheets_service
    response_values = fetch_response_values(sheets_service)
    column_indices = get_column_indices(response_values[2])

    values = construct_values(topic_id, found_page, project)

    update_sheet_cells(sheets_service, column_indices, response_values.count, values)

    ExportTopicIntoSheetJob.set(wait: 15.seconds).perform_later(found_page.published_revision)
  end

  private

  def fetch_response_values(sheets_service)
    response = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_ID'], 'A:Z')
    response.values
  end

  def get_column_indices(header_row)
    COLUMN_NAMES.map { |name| header_row.index(name) }
  end

  def construct_values(topic_id, found_page, project)
    title_parametrized = found_page.latest_revision.title.parameterize
    [
      found_page.latest_revision.title,
      project.id,
      %(=HYPERLINK("https://platforma.slovensko.digital/t/#{title_parametrized}/#{topic_id}"; "Platforma link")),
      '',
      '',
      topic_id.to_s,
      found_page.published_revision.present? ? 'Áno' : 'Nie',
      found_page.published_revision&.updated_at&.in_time_zone('Europe/Bratislava')&.strftime('%H:%M %d.%m.%Y') || '',
      found_page.published_revision.present? ? %(=HYPERLINK("https://redflags.slovensko.digital/admin/pages/#{found_page.id}"; "Admin link")) : ''
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