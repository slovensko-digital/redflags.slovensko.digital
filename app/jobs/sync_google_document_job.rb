class SyncGoogleDocumentJob < ApplicationJob
  queue_as :default

  def perform(project_name, project_id, google_document_id, page_id, page_type)
    parsed_content = parse_google_doc(google_document_id)
    create_or_update_page(project_name, project_id, google_document_id, page_id, page_type, parsed_content)
  end

  def create_or_update_page(project_name, project_id, google_document_id, page_id, page_type, parsed_content)
    Page.transaction do
      page = Page.find_or_create_by!(id: page_id) do |new_page|
        new_project = Project.find_or_create_by(id: project_id)
        new_page.project = new_project
      end

      drive_service = GoogleApiService.get_drive_service
      revisions = drive_service.list_revisions(google_document_id)&.revisions&.count
      version = revisions

      revision = page.revisions.find_or_initialize_by(version: version)
      revision.title = project_name
      revision.raw = parsed_content
      revision.load_ratings(parsed_content)
      revision.save!

      page.latest_revision = revision
      page.page_type = page_type
      page.save!
    end
=begin
    Page.transaction do
      page = setup_page(project_id, page_id)
      revision = setup_revision(page, project_name, parsed_content, google_document_id)
      update_page_info(page, page_type, revision)
    end
=end
  end

  def setup_page(project_id, page_id)
    Page.find_or_create_by!(id: page_id) do |new_page|
      new_project = Project.find_or_create_by!(id: project_id)
      new_page.project = new_project
    end
  end

  def setup_revision(page, project_name, parsed_content, google_document_id)
    drive_service = GoogleApiService.get_drive_service
    revisions = drive_service.list_revisions(google_document_id)&.revisions&.count
    version = revisions
    revision = page.revisions.find_or_initialize_by(version: version)
    revision.title = project_name
    revision.raw = parsed_content
    revision.load_ratings(parsed_content)
    revision.save!
    revision
  end

  def update_page_info(page, page_type, revision)
    page.latest_revision = revision
    page.page_type = page_type
    page.save!
  end

  def parse_google_doc(google_document_id)
    document = GoogleApiService.get_document(google_document_id)
    parser_service = DocumentParserService.new(document)

    html_content = parser_service.to_html
    parser_service.to_hash(html_content)
  end
end