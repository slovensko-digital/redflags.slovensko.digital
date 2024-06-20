class SyncOneTopicJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = ['Projekt', 'Projekt ID', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'].freeze

  def perform(page_id)
    sheets_service = GoogleApiService.get_sheets_service
    response_values = sheets_service.get_spreadsheet_values(ENV.fetch('GOOGLE_SHEET_ID'), 'A:Z')&.values

    indices = find_indices(response_values[2])
    row = response_values[3..-1].find do |row|
      row[indices["ID prípravy"]] == page_id.to_s || row[indices["ID produktu"]] == page_id.to_s
    end

    process_row(row, indices, page_id) if row
  end

  private

  def find_indices(header_row)
    indices = COLUMN_NAMES.map { |name| [name, header_row.index(name)] }.to_h
    return indices if indices.values.all?

    raise ArgumentError, "Could not find required columns in the spreadsheet."
  end

  def process_row(row, indices, target_id)
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
      if target_id == preparation_page_id.to_i
        enqueue_job_for_update("#{project_name} - Príprava", project_id, preparation_document_id, preparation_page_id, 0)
      else target_id == product_page_id.to_i
        enqueue_job_for_update("#{project_name} - Produkt", project_id, product_document_id, product_page_id, 1)
      end
    end
  end

  def enqueue_job_for_update(name, project_id, document_id, page_id, page_type)
    SyncGoogleDocumentJob.perform_later(name, project_id, document_id, page_id, page_type)
  end
end