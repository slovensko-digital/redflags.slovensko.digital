class ExportTopicIntoSheetJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = [
    'Projekt', 'Projekt ID', 'ID hodnotenia', 'Typ hodnotenia', 'Názov', 'Popis', 'Náklady', 'Garant', 'Zhrnutie',
    'Stanovisko S.D', 'Aktuálny stav', 'Čo sa deje', 'Reforma VS body', 'Reforma VS', 'Merateľné ciele (KPI) body',
    'Merateľné ciele (KPI)', 'Postup dosiahnutia cielov body', 'Postup dosiahnutia cielov', 'Súlad s KRIS body',
    'Súlad s KRIS', 'Biznis prínos body', 'Biznis prínos', 'Príspevok v informatizácií body', 'Príspevok v informatizácií',
    'Štúdia uskutočniteľnosti body', 'Štúdia uskutočniteľnosti', 'Alternatívy body', 'Alternatívy', 'Kalkulácia efektívnosti body',
    'Kalkulácia efektívnosti', 'Participácia na príprave projektu body', 'Participácia na príprave projektu', 'Súlad s požiadavkami body',
    'Súlad s požiadavkami', 'Elektronické služby body', 'Elektronické služby', 'Identifikácia, autentifikácia, autorizácia (IAA) body',
    'Identifikácia, autentifikácia, autorizácia (IAA)', 'Riadenie údajov body', 'Riadenie údajov', 'OpenData body', 'OpenData',
    'MyData body', 'MyData', 'OpenApi body', 'OpenApi', 'Zdrojový kód body', 'Zdrojový kód'
  ].freeze

  def perform(new_revision)
    if new_revision.published?
      update_sheet(new_revision)
    else
      delete_row(new_revision)
    end
  end

  private

  def update_sheet(new_revision)
    result = extract_content_from_html(new_revision.body_html)

    result["Projekt"] = new_revision.title
    result["Projekt ID"] = new_revision.project_id
    result["ID hodnotenia"] = new_revision.revision.page.id
    result["Typ hodnotenia"] = new_revision.revision.page.page_type
    result["Názov"] = new_revision.title
    result["Popis"] = new_revision.description
    result["Náklady"] = new_revision.budget
    result["Garant"] = new_revision.guarantor
    result["Zhrnutie"] = new_revision.summary
    result["Stanovisko S.D"] = new_revision.recommendation
    result["Aktuálny stav"] = new_revision.stage_id
    result["Čo sa deje"] = new_revision.current_status

    result["Reforma VS body"] = new_revision.revision.ratings.where(rating_type_id: 1).first&.score || 'N/A'
    result["Merateľné ciele (KPI) body"] = new_revision.revision.ratings.where(rating_type_id: 2).first&.score || 'N/A'

    sheets_service = GoogleApiService.get_sheets_service
    response = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_EXPORT_ID'], 'A:BA')
    header_row = response.values[2]
    current_row_count = response.values.size
    column_indices = COLUMN_NAMES.map { |name| header_row.index(name) }

    values = COLUMN_NAMES.map { |name| result[name] || "-" }
    update_google_sheet(sheets_service, ENV['GOOGLE_SHEET_EXPORT_ID'], column_indices, values, current_row_count)
  end

  def delete_row(new_revision)
    sheets_service = GoogleApiService.get_sheets_service
    response = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_EXPORT_ID'], 'A:BA')
    header_row = response.values[2]

    row_index = find_row_index(response.values[3..-1], header_row, new_revision.revision.page.id)

    if row_index
      delete_google_sheet_row(sheets_service, ENV['GOOGLE_SHEET_EXPORT_ID'], row_index + 3)
    else
      raise ArgumentError, "No data found for the given page_id in the spreadsheet. ID may not match or is not in string format."
    end
  end

  def extract_content_from_html(body_html)
    result = {}
    doc = Nokogiri::HTML(body_html)
    doc.css('h3').each do |header|
      siblings = header.xpath('following-sibling::*[not(self::div)]').take_while { |node| node.name != 'h3' }
      content = siblings.map { |sibling| sibling.text.strip }.join(' ')
      result[header.text.strip] = content
    end
    result
  end

  def update_google_sheet(sheets_service, google_sheet_id, column_indices, values, current_row_count)
    values.each_with_index do |value, i|
      range = "Hárok1!#{(column_indices[i] + 65).chr}#{current_row_count + 1}"
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [[value]])
      sheets_service.update_spreadsheet_value(google_sheet_id, range, value_range_object, value_input_option: 'USER_ENTERED')
    end
  end

  def delete_google_sheet_row(sheets_service, google_sheet_id, row_index)
    request_body = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(
      requests: [
        {
          delete_dimension: {
            range: {
              sheet_id: get_sheet_id(sheets_service, google_sheet_id),
              dimension: 'ROWS',
              start_index: row_index - 1,
              end_index: row_index
            }
          }
        }
      ]
    )
    sheets_service.batch_update_spreadsheet(google_sheet_id, request_body)
  end

  def get_sheet_id(sheets_service, google_sheet_id)
    spreadsheet = sheets_service.get_spreadsheet(google_sheet_id)
    spreadsheet.sheets.first.properties.sheet_id
  end

  def find_row_index(rows, header_row, page_id)
    id_index = header_row.index('ID hodnotenia')
    rows.find_index { |row| row[id_index] == page_id.to_s }
  end
end
