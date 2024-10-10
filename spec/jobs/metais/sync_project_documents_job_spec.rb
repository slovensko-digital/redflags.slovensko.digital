require 'rails_helper'

RSpec.describe Metais::SyncProjectDocumentsJob, type: :job do
  include ActiveJob::TestHelper

  let(:latest_version) do
    double('LatestVersion',
           nazov: 'Document Title',
           filename: 'document.pdf')
  end

  let(:document) do
    double('Document',
           uuid: 'doc-uuid',
           latest_version: latest_version)
  end

  let(:metais_project) do
    double('MetaisProject', documents: [document])
  end

  let(:project_origin) { double('ProjectOrigin') }
  let(:project_document) { instance_double(Metais::ProjectDocument, save!: true) }

  before do
    allow(Metais::ProjectDocument).to receive(:find_or_initialize_by).and_return(project_document)

    allow(Metais::OriginType).to receive(:find_by).with(name: 'MetaIS').and_return(double('OriginType'))

    allow(project_document).to receive(:name=)
    allow(project_document).to receive(:filename=)
    allow(project_document).to receive(:value=)
    allow(project_document).to receive(:description=)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'processes each document and creates or updates ProjectDocument records' do
    Metais::SyncProjectDocumentsJob.perform_now(project_origin, metais_project)

    expect(Metais::ProjectDocument).to have_received(:find_or_initialize_by).with(
      uuid: document.uuid,
      project_origin: project_origin,
      origin_type: anything
    )

    expect(project_document).to have_received(:name=).with('Document Title')
    expect(project_document).to have_received(:filename=).with('document.pdf')
    expect(project_document).to have_received(:value=).with('https://metais.vicepremier.gov.sk/dms/file/doc-uuid')
    expect(project_document).to have_received(:description=).with('MetaIS')

    expect(project_document).to have_received(:save!)
  end
end
