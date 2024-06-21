class SyncAllTopicsJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'].freeze

  def perform
    sheets_service = GoogleApiService.get_sheets_service
    response_values = sheets_service.get_spreadsheet_values(ENV.fetch('GOOGLE_SHEET_ID'), 'A:Z')&.values

    indices = find_indices(response_values[2])
    response_values[3..-1].each { |row| process_row(row, indices) }
  end

  private

  def find_indices(header_row)
    indices = COLUMN_NAMES.map { |name| [name, header_row.index(name)] }.to_h
    return indices if indices.values.all?

    raise ArgumentError, "Could not find required columns in the spreadsheet."
  end

  def process_row(row, indices)
    project_name = row[indices["Projekt"]]
    project_id = row[indices["Projekt ID"]]
    platform_link = row[indices["Platforma"]]
    preparation_document_id = row[indices["ID draft prípravy"]]
    preparation_page_id = row[indices["ID prípravy"]]
    product_document_id = row[indices["ID draft produktu"]]
    product_page_id = row[indices["ID produktu"]]

    if platform_link != ''
      SyncTopicJob.perform_later(project_id, preparation_page_id)
    else
      enqueue_job_for_update("#{project_name} - Príprava", project_id, preparation_document_id, preparation_page_id, 'Prípravná fáza')
    end
    enqueue_job_for_update("#{project_name} - Produkt", project_id, product_document_id, product_page_id, 'Fáza produkt')
  end

  def enqueue_job_for_update(name, project_id, document_id, page_id, page_type)
    SyncGoogleDocumentJob.perform_later(name, project_id, document_id, page_id, page_type)
  end
end
