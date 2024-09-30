require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Metais::SyncProjectSuppliersJob, type: :job do
  include ActiveJob::TestHelper

  let!(:origin_type) { Metais::OriginType.create!(name: 'MetaIS') }

  let!(:supplier_type_nfp) { Metais::SupplierType.create!(name: "NFP") }
  let!(:supplier_type_vo) { Metais::SupplierType.create!(name: "VO") }
  let!(:supplier_type_crz) { Metais::SupplierType.create!(name: "CRZ") }

  let!(:metais_project) { create(:metais_project) }
  let(:project_origin) { Metais::ProjectOrigin.create!(project: metais_project, origin_type: origin_type, title: "Test") }

  let(:latest_version) { double('LatestVersion', kod_metais: 'code1', link_nfp: "http://example.com/nfp", datum_nfp: Date.today, vo: "http://example.com/vo", vyhlasenie_vo: Date.today, zmluva_o_dielo_crz: "http://example.com/crz", zmluva_o_dielo: Date.today) }
  let(:datahub_project) { instance_double(Datahub::Metais::Project, uuid: 'uuid1', latest_version: latest_version) }

  before do
    allow(datahub_project).to receive(:latest_version).and_return(latest_version)

    allow(Metais::OriginType).to receive(:find_by).with(name: 'MetaIS').and_return(origin_type)
    allow(Metais::SupplierType).to receive(:find_by).with(name: "NFP").and_return(supplier_type_nfp)
    allow(Metais::SupplierType).to receive(:find_by).with(name: "VO").and_return(supplier_type_vo)
    allow(Metais::SupplierType).to receive(:find_by).with(name: "CRZ").and_return(supplier_type_crz)

    crz_html = <<-HTML
      <html>
      <body>
        <ul>
          <li class='py-2 border-top'>
            <strong class='col-sm-3 text-sm-end'>Dodávateľ:</strong>
            <span class='col-sm-9'>Supplier Name</span>
          </li>
          <li class='py-2 border-top'>
            <strong class='col-sm-3 text-sm-end'>IČO:</strong>
            <span class='col-sm-9'>12345678</span>
          </li>
        </ul>
      </body>
      </html>
    HTML
    stub_request(:get, "http://example.com/crz").to_return(body: crz_html, headers: { 'Content-Type' => 'text/html' })
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:open).with("http://example.com/crz").and_return(StringIO.new(crz_html))

    allow(Metais::ProjectSupplier).to receive(:find_or_initialize_by).and_call_original
    allow(project_origin).to receive(:supplier=).and_call_original
    allow(project_origin).to receive(:supplier_cin=).and_call_original
    allow(project_origin).to receive(:save!).and_call_original

    Metais::SyncProjectSuppliersJob.perform_now(project_origin, datahub_project)
  end

  describe '#perform' do
    context 'when processing NFP links' do
      it 'creates project suppliers for valid NFP links' do
        expect(Metais::ProjectSupplier).to have_received(:find_or_initialize_by)
          .with(hash_including(name: 'http://example.com/nfp', value: 'http://example.com/nfp', date: Date.today, origin_type: origin_type, supplier_type: supplier_type_nfp))
      end
    end

    context 'when processing VO links' do
      it 'creates project suppliers for valid VO links' do
        expect(Metais::ProjectSupplier).to have_received(:find_or_initialize_by)
          .with(hash_including(name: 'http://example.com/vo', value: 'http://example.com/vo', date: Date.today, origin_type: origin_type, supplier_type: supplier_type_vo))
      end
    end

    context 'when processing CRZ links' do
      it 'scrapes supplier data from the CRZ page and updates the project_origin' do
        expect(project_origin).to have_received(:supplier=).with('Supplier Name')
        expect(project_origin).to have_received(:supplier_cin=).with('12345678')
        expect(project_origin).to have_received(:save!)
      end

      it 'creates project suppliers for valid CRZ links' do
        expect(Metais::ProjectSupplier).to have_received(:find_or_initialize_by)
          .with(hash_including(name: 'http://example.com/crz', value: 'http://example.com/crz', date: Date.today, origin_type: origin_type, supplier_type: supplier_type_crz))
      end
    end
  end
end