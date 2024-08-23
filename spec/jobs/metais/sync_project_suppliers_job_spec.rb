require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::SyncProjectSuppliersJob, type: :job do
  include ActiveJob::TestHelper

  let(:latest_version) do
    double('LatestVersion',
           link_nfp: 'http://example.com/nfp',
           datum_nfp: Date.today,
           vo: 'http://example.com/vo',
           vyhlasenie_vo: Date.today,
           zmluva_o_dielo_crz: 'http://example.com/crz',
           zmluva_o_dielo: Date.today)
  end

  let(:metais_project) do
    double('MetaisProject', latest_version: latest_version)
  end

  let(:project_origin) { double('ProjectOrigin') }
  let(:project_supplier) { instance_double(Metais::ProjectSupplier, save!: true) }

  before do
    # Stub HTTP requests
    stub_request(:get, 'http://example.com/crz').to_return(status: 200, body: "response body", headers: {})

    allow(Metais::ProjectSupplier).to receive(:find_or_initialize_by).and_return(project_supplier)
    allow(Metais::OriginType).to receive(:find_by).with(name: 'MetaIS').and_return(double('OriginType'))

    allow(project_supplier).to receive(:name=)
    allow(project_supplier).to receive(:value=)
    allow(project_supplier).to receive(:date=)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'processes each supplier and creates or updates ProjectSuppliers records' do
    Metais::SyncProjectSuppliersJob.perform_now(project_origin, metais_project)

    expect(Metais::ProjectSupplier).to have_received(:find_or_initialize_by).with(
      name: 'http://example.com/nfp',
      value: 'http://example.com/nfp',
      date: Date.today,
      project_origin: project_origin,
      origin_type: anything,
      supplier_type: anything
    )

    expect(project_supplier).to have_received(:name=).with('http://example.com/nfp')
    expect(project_supplier).to have_received(:value=).with('http://example.com/nfp')
    expect(project_supplier).to have_received(:date=).with(Date.today)
    expect(project_supplier).to have_received(:save!)
  end
end
