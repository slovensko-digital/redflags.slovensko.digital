require 'rails_helper'

RSpec.describe SyncGoogleDocumentJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(project_name, project_id, google_document_id, page_id, page_type) }

  let(:project_name) { 'Project1' }
  let(:project_id) { 'ABC1' }
  let(:google_document_id) { 'DOC1' }
  let(:page_id) { 'PAGE1' }
  let(:page_type) { 0 }
  let(:drive_service) { instance_double(Google::Apis::DriveV3::DriveService) }
  let(:revisions_count) { 1 }
  let(:document) { instance_double('Google::Apis::DocsV1::Document') }
  let(:parser_service) { instance_double('DocumentParserService') }
  let(:html_content) { '<html>Content</html>' }
  let(:parsed_hash) { {content: 'Parsed content'} }
  let(:page) { create(:page) }
  let(:revision) { create(:revision) }

  before do
    allow(Page).to receive_message_chain(:find_or_create_by!).and_return(page)
    allow(Project).to receive_message_chain(:find_or_create_by!).and_return(instance_double('Project'))
    allow(GoogleApiService).to receive(:get_drive_service).and_return(drive_service)
    allow(drive_service).to receive(:list_revisions).and_return(instance_double(Google::Apis::DriveV3::RevisionList, revisions: Array.new(revisions_count)))
    allow(GoogleApiService).to receive(:get_document).and_return(document)
    allow(DocumentParserService).to receive(:new).with(document).and_return(parser_service)
    allow(parser_service).to receive(:to_html).and_return(html_content)
    allow(parser_service).to receive(:to_hash).with(html_content).and_return(revision.raw)
    allow(page).to receive(:revisions).and_return(Revision)
    allow(Revision).to receive(:find_or_initialize_by).and_return(revision)
    allow(revision.phase_revision).to receive(:load_ratings).with(revision.raw)
  end

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
                        .on_queue("default")
                        .with(project_name, project_id, google_document_id, page_id, page_type)
                        .at(:no_wait)
  end

  context 'when performing the job' do
    it 'invokes methods in correct sequence' do
      described_class.perform_now(project_name, project_id, google_document_id, page_id, page_type)

      expect(GoogleApiService).to have_received(:get_drive_service)
      expect(drive_service).to have_received(:list_revisions)
      expect(GoogleApiService).to have_received(:get_document)
      expect(DocumentParserService).to have_received(:new).with(document)
      expect(parser_service).to have_received(:to_html)
      expect(parser_service).to have_received(:to_hash).with(html_content)
      expect(page).to have_received(:revisions)
      expect(Revision).to have_received(:find_or_initialize_by)
    end
  end

  context 'when GoogleApiService raises error' do
    before do
      allow(GoogleApiService).to receive(:get_drive_service).and_raise(StandardError.new)
    end

    it 'raises an exception' do
      expect { described_class.perform_now(project_name, project_id, google_document_id, page_id, page_type) }
        .to raise_error(StandardError)
    end
  end
end