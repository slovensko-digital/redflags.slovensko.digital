class ExportTopicIntoSheetJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = [
    'Projekt', 'Projekt ID', 'ID hodnotenia prípravy', 'Link na hodnotenie prípravy', 'ID hodnotenia produktu', 'Link na hodnotenie produktu',
    'Názov-Príprava', 'Garant-Príprava', 'Stručný opis-Príprava', 'Náklady na projekt-Príprava', 'Aktuálny stav projektu-Príprava',
    'Čo sa práve deje-Príprava', 'Zhrnutie hodnotenia Red Flags-Príprava', 'Stanovisko Slovensko.Digital-Príprava', 'Reforma VS body-Príprava',
    'Reforma VS-Príprava', 'Merateľné ciele (KPI) body-Príprava', 'Merateľné ciele (KPI)-Príprava', 'Postup dosiahnutia cieľov body-Príprava',
    'Postup dosiahnutia cieľov-Príprava', 'Súlad s KRIT body-Príprava', 'Súlad s KRIT-Príprava', 'Biznis prínos body-Príprava',
    'Biznis prínos-Príprava', 'Príspevok v informatizácii body-Príprava', 'Príspevok v informatizácii-Príprava', 'Štúdia uskutočniteľnosti body-Príprava',
    'Štúdia uskutočniteľnosti-Príprava', 'Alternatívy body-Príprava', 'Alternatívy-Príprava', 'Kalkulácia efektívnosti body-Príprava',
    'Kalkulácia efektívnosti-Príprava', 'Transparentnosť a participácia body-Príprava', 'Transparentnosť a participácia-Príprava',
    'Participácia na príprave projektu body-Príprava', 'Participácia na príprave projektu-Príprava', 'Názov-Produkt',
    'Garant-Produkt', 'Stručný opis-Produkt', 'Náklady na projekt-Produkt', 'Aktuálny stav projektu-Produkt', 'Čo sa práve deje-Produkt',
    'Zhrnutie hodnotenia Red Flags-Produkt', 'Stanovisko Slovensko.Digital-Produkt', 'Reforma VS body-Produkt', 'Reforma VS-Produkt',
    'Merateľné ciele (KPI) body-Produkt', 'Merateľné ciele (KPI)-Produkt', 'Postup dosiahnutia cieľov body-Produkt', 'Postup dosiahnutia cieľov-Produkt',
    'Súlad s KRIT body-Produkt', 'Súlad s KRIT-Produkt', 'Biznis prínos body-Produkt', 'Biznis prínos-Produkt', 'Príspevok v informatizácii body-Produkt',
    'Príspevok v informatizácii-Produkt', 'Kalkulácia efektívnosti body-Produkt', 'Kalkulácia efektívnosti-Produkt', 'Transparentnosť a participácia body-Produkt',
    'Transparentnosť a participácia-Produkt', 'Súlad s požiadavkami body-Produkt', 'Súlad s požiadavkami-Produkt', 'Elektronické služby body-Produkt',
    'Elektronické služby-Produkt', 'Identifikácia, autentifikácia, autorizácia (IAA) body-Produkt', 'Identifikácia, autentifikácia, autorizácia (IAA)-Produkt',
    'Riadenie údajov body-Produkt', 'Riadenie údajov-Produkt', 'OpenData body-Produkt', 'OpenData-Produkt', 'MyData body-Produkt', 'MyData-Produkt',
    'OpenAPI body-Produkt', 'OpenAPI-Produkt', 'Zdrojový kód body-Produkt', 'Zdrojový kód-Produkt'
  ].freeze

  RATINGS_CONSTANT = {
    "Reforma VS" => "Reforma VS body",
    "Merateľné ciele (KPI)" => "Merateľné ciele (KPI) body",
    "Postup dosiahnutia cieľov" => "Postup dosiahnutia cieľov body",
    "Súlad s KRIS" => "Súlad s KRIT body",
    "Súlad s KRIT" => "Súlad s KRIT body",
    "Biznis prínos" => "Biznis prínos body",
    "Príspevok v informatizácii" => "Príspevok v informatizácii body",
    "Štúdia uskutočniteľnosti" => "Štúdia uskutočniteľnosti body",
    "Alternatívy" => "Alternatívy body",
    "Kalkulácia efektívnosti" => "Kalkulácia efektívnosti body",
    "Transparentnosť a participácia" => "Transparentnosť a participácia body",
    "Participácia na príprave projektu" => "Participácia na príprave projektu body",
    "Súlad s požiadavkami" => "Súlad s požiadavkami body",
    "Elektronické služby" => "Elektronické služby body",
    "Identifikácia, autentifikácia, autorizácia (IAA)" => "Identifikácia, autentifikácia, autorizácia (IAA) body",
    "Riadenie údajov" => "Riadenie údajov body",
    "OpenData" => "OpenData body",
    "MyData" => "MyData body",
    "OpenAPI" => "OpenAPI body",
    "Zdrojový kód" => "Zdrojový kód body"
  }

  def perform(new_revision)
    if new_revision.published?
      update_sheet(new_revision)
    else
      delete_row(new_revision)
    end
  end

  private

  def update_sheet(new_revision)
    suffix = new_revision.phase.phase_type.name == 'Prípravná fáza' ? '-Príprava' : '-Produkt'

    result = extract_content_from_html(new_revision.body_html)
    ratings = new_revision.ratings.includes(:rating_type).index_by { |rating| rating.rating_type.name }

    result["Názov"] = new_revision.title
    result["Garant"] = new_revision.guarantor
    result["Stručný opis"] = new_revision.description
    result["Náklady na projekt"] = new_revision.budget
    result["Aktuálny stav projektu"] = new_revision.stage&.name || 'N/A'
    result["Čo sa práve deje"] = new_revision.current_status
    result["Zhrnutie hodnotenia Red Flags"] = new_revision.summary
    result["Stanovisko Slovensko.Digital"] = new_revision.recommendation

    RATINGS_CONSTANT.each do |type_name, result_field_name|
      result[result_field_name] = ratings[type_name]&.score || 'N/A'
    end

    result.transform_keys! { |k| k + suffix }

    result["Projekt"] = new_revision.title
    result["Projekt ID"] = new_revision.phase.project_id

    if new_revision.phase.phase_type.name == 'Prípravná fáza'
      result["ID hodnotenia prípravy"] = new_revision.revision.page.id
      result["Link na hodnotenie prípravy"] = %(=HYPERLINK("https://redflags.slovensko.digital/admin/pages/#{new_revision.revision.page.id}"; "Hodnotenie v adminovi"))
    else
      result["ID hodnotenia produktu"] = new_revision.revision.page.id
      result["Link na hodnotenie produktu"] = %(=HYPERLINK("https://redflags.slovensko.digital/admin/pages/#{new_revision.revision.page.id}"; "Hodnotenie v adminovi"))
    end

    sheets_service = GoogleApiService.get_sheets_service
    response = sheets_service.get_spreadsheet_values(ENV['GOOGLE_SHEET_EXPORT_ID'], 'A:CA')
    header_row = response.values[2]
    current_row_count = response.values.count
    column_indices = COLUMN_NAMES.map { |name| header_row.index(name) }

    values = COLUMN_NAMES.map { |name| result[name]  }

    if find_row_index_by_project_id(response.values[3..], header_row, new_revision.phase.project_id)
      range = "Hárok1!#{column_letter(column_indices.min + 1)}#{current_row_count}:#{column_letter(column_indices.max + 1)}#{current_row_count}"
    else
      range = "Hárok1!#{column_letter(column_indices.min + 1)}#{current_row_count + 1}:#{column_letter(column_indices.max + 1)}#{current_row_count + 1}"
    end
    update_google_sheet(sheets_service, ENV['GOOGLE_SHEET_EXPORT_ID'], column_indices, values, range)
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

  def update_google_sheet(sheets_service, google_sheet_id, column_indices, values, range)
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [values])
    sheets_service.update_spreadsheet_value(google_sheet_id, range, value_range_object, value_input_option: 'USER_ENTERED')
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

  def find_row_index_by_project_id(rows, header_row, project_id)
    project_id_index = header_row.index('Projekt ID')
    rows.find_index { |row| row[project_id_index] == project_id.to_s }
  end

  def column_letter(number)
    letter = ''
    while number > 0
      number, remainder = (number - 1).divmod(26)
      letter = (65 + remainder).chr + letter
    end
    letter
  end
end
