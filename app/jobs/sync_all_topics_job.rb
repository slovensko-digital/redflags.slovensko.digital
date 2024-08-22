class SyncAllTopicsJob < ApplicationJob
  queue_as :default

  COLUMN_NAMES = ['Projekt', 'Projekt ID', 'MetaIS', 'Platforma', 'ID draft prípravy', 'ID prípravy', 'ID draft produktu', 'ID produktu'].freeze

  def perform(sync_all: true)
    sheets_service = GoogleApiService.get_sheets_service
    response_values = sheets_service.get_spreadsheet_values(ENV.fetch('GOOGLE_SHEET_ID'), 'A:Z')&.values

    indices = find_indices(response_values[2])
    response_values[3..-1].each { |row| process_row(row, indices, sync_all) }
  end

  private

  def find_indices(header_row)
    indices = COLUMN_NAMES.map { |name| [name, header_row.index(name)] }.to_h
    return indices if indices.values.all?

    raise ArgumentError, "Could not find required columns in the spreadsheet."
  end

  def process_row(row, indices, sync_all)
    project_metais_code = row[indices["MetaIS"]]
    project_name = row[indices["Projekt"]]
    project_id = row[indices["Projekt ID"]]
    platform_link = row[indices["Platforma"]]
    preparation_document_id = row[indices["ID draft prípravy"]]
    preparation_page_id = row[indices["ID prípravy"]]
    product_document_id = row[indices["ID draft produktu"]]
    product_page_id = row[indices["ID produktu"]]

    project = Project.find_by(id: project_id)
    project.metais_code = project_metais_code
    project.save!

    if sync_all
      process_row_for_sync_all(project_name, project_id, platform_link, preparation_document_id, preparation_page_id, product_document_id, product_page_id)
    else
      process_row_for_google_sync(project_name, project_id, preparation_document_id, preparation_page_id, product_document_id, product_page_id)
    end
  end

  def process_row_for_sync_all(project_name, project_id, platform_link, preparation_document_id, preparation_page_id, product_document_id, product_page_id)
    if platform_link.present?
      SyncTopicJob.perform_later(project_id, preparation_page_id)
    else
      enqueue_job_for_update("#{project_name} - Príprava", project_id, preparation_document_id, preparation_page_id, 'Prípravná fáza')
    end
    enqueue_job_for_update("#{project_name} - Produkt", project_id, product_document_id, product_page_id, 'Fáza produkt')
  end

  def process_row_for_google_sync(project_name, project_id, preparation_document_id, preparation_page_id, product_document_id, product_page_id)
    if preparation_document_id.present?
      enqueue_job_for_update("#{project_name} - Príprava", project_id, preparation_document_id, preparation_page_id, 'Prípravná fáza')
    end
    if product_document_id.present?
      enqueue_job_for_update("#{project_name} - Produkt", project_id, product_document_id, product_page_id, 'Fáza produkt')
    end
  end

  def enqueue_job_for_update(name, project_id, document_id, page_id, page_type)
    unless has_template_name?(document_id)
      SyncGoogleDocumentJob.perform_now(name, project_id, document_id, page_id, page_type)
    end
  end

  def has_template_name?(document_id)
    document_name = GoogleApiService.get_document(document_id)&.title
    document_name == 'Kópia dokumentu RF-priprava-template' || document_name == 'Kópia dokumentu RF-produkt-template'
  end
end
