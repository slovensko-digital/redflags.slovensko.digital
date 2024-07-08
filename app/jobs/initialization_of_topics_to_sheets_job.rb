class InitializationOfTopicsToSheetsJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = ['Projekt', 'Projekt ID', 'Gestor', 'Platforma', 'Draft prípravy', 'ID draft prípravy', 'ID prípravy', 'Príprava publikovaná?', 'Dátum publikácie prípravy', 'RF web príprava'].freeze

  def perform(topic_id, found_page, project)
    create_new_row

    sheets_service = GoogleApiService.get_sheets_service

    new_row_index = poll_for_new_row(sheets_service)

    if new_row_index.nil?
      Rails.logger.error("Failed to create a new row in Google Sheets.")
      return
    end

    response_values = fetch_response_values(sheets_service)
    column_indices = get_column_indices(response_values[2])

    values = construct_values(topic_id, found_page, project)

    update_sheet_cells(sheets_service, column_indices, response_values.count, values)

    ExportTopicIntoSheetJob.set(wait: 30.seconds).perform_later(found_page.published_revision.phase_revision) if found_page.published_revision.present?
  end

  private

  def create_new_row
    uri = URI(ENV['GOOGLE_SHEET_SCRIPT_URL'])
    Net::HTTP.get(uri)
  end

  def fetch_response_values(sheets_service)
    response = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_ID'], 'A:Z')
    response.values
  end

  def get_column_indices(header_row)
    COLUMN_NAMES.map { |name| header_row.index(name) }
  end

  def construct_values(topic_id, found_page, project)
    title_parametrized = found_page.latest_revision.title.parameterize

    phase_revision_title = found_page.latest_revision.phase_revision.nil? ?
                             nil : found_page.latest_revision.phase_revision.title
    phase_revision_guarantor = found_page.latest_revision.phase_revision&.guarantor

    [
      phase_revision_title || found_page.latest_revision.title,
      project.id,
      phase_revision_guarantor || '',
      %(=HYPERLINK("https://platforma.slovensko.digital/t/#{title_parametrized}/#{topic_id}"; "Platforma link")),
      '',
      '',
      topic_id.to_s,
      found_page.published_revision.present? ? 'Áno' : 'Nie',
      found_page.published_revision&.created_at&.in_time_zone('Europe/Bratislava')&.strftime('%H:%M %d.%m.%Y') || '',
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

  def poll_for_new_row(sheets_service, max_attempts = 10, sleep_duration = 3)
    max_attempts.times do
      response_values = fetch_response_values(sheets_service)
      new_row_index = response_values.count

      if initial_values_in_last_row?(response_values.last)
        return new_row_index
      end

      sleep(sleep_duration)
    end
    nil
  end

  def initial_values_in_last_row?(last_row)
    initial_values = ['Nie', 'Nie']
    (last_row & initial_values).any?
  end
end