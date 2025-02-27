require 'rails_helper'

RSpec.describe Metais::SyncProjectSuppliersJob, type: :job do
  let!(:origin_type) { Metais::OriginType.create!(name: 'MetaIS') }

  let(:supplier_type_nfp) { Metais::SupplierType.create!(name: "NFP") }
  let(:supplier_type_vo) { Metais::SupplierType.create!(name: "VO") }
  let(:supplier_type_crz) { Metais::SupplierType.create!(name: "CRZ") }

  let!(:metais_project) { create(:metais_project) }
  let(:project_origin) { Metais::ProjectOrigin.create!(project: metais_project, origin_type: origin_type, title: "Test") }

  let(:latest_version) { double('LatestVersion', kod_metais: 'code1', link_nfp: "http://example.com/nfp", datum_nfp: Date.today, vo: "http://example.com/vo", vyhlasenie_vo: Date.today, zmluva_o_dielo_crz: "http://example.com/crz", zmluva_o_dielo: Date.today) }
  let(:datahub_project) { instance_double(Datahub::Metais::Project, uuid: 'uuid1', latest_version: latest_version) }

  before do
    allow(datahub_project).to receive(:latest_version).and_return(latest_version)

    allow(Metais::SupplierType).to receive(:find_by).with(name: "NFP").and_return(supplier_type_nfp)
    allow(Metais::SupplierType).to receive(:find_by).with(name: "VO").and_return(supplier_type_vo)
    allow(Metais::SupplierType).to receive(:find_by).with(name: "CRZ").and_return(supplier_type_crz)
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:extract_links).and_return([])

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
  end

  it 'creates ProjectSupplier records for NFP links' do
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:extract_links).with('http://example.com/nfp').and_return(['http://supplier1.com', 'http://supplier2.com'])
    expect { described_class.perform_now(project_origin, datahub_project) }.to change(Metais::ProjectSupplier, :count).by(2)

    suppliers = Metais::ProjectSupplier.where(supplier_type: supplier_type_nfp)
    expect(suppliers.map(&:name)).to contain_exactly('http://supplier1.com', 'http://supplier2.com')
  end

  it 'creates ProjectSupplier records for VO links' do
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:extract_links).with('http://example.com/vo').and_return(['http://supplier3.com'])
    expect { described_class.perform_now(project_origin, datahub_project) }.to change(Metais::ProjectSupplier, :count).by(1)

    supplier = Metais::ProjectSupplier.find_by(name: 'http://supplier3.com')
    expect(supplier).to be_present
    expect(supplier.supplier_type).to eq(supplier_type_vo)
  end

  it 'updates project_origin with supplier info for CRZ links' do
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:extract_links).with('http://example.com/crz').and_return(['http://supplier4.com'])
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:valid_url?).and_return(true)

    # Mock the parsing to return specific values
    allow_any_instance_of(Metais::SyncProjectSuppliersJob).to receive(:parse_crz_document).and_return({ supplier: 'Supplier Info', cin: 12345678 })

    expect { described_class.perform_now(project_origin, datahub_project) }.to change(Metais::ProjectSupplier, :count).by(1)

    expect(project_origin.supplier).to eq('Supplier Info')
    expect(project_origin.supplier_cin).to eq(12345678)
  end
end
