require 'rails_helper'

RSpec.describe Metais::SyncProjectJob, type: :job do
  include ActiveJob::TestHelper

  let(:latest_version) do
    double('LatestVersion',
           nazov: 'Project Title',
           popis: 'Project Description',
           status: 'Active',
           faza_projektu: 'Phase 1',
           prijimatel: 'Guarantor Name',
           metais_created_at: Time.now,
           datum_zacatia: Date.today,
           termin_ukoncenia: Date.today + 1.year,
           zmena_stavu: Date.today,
           program: 'Program UUID',
           suma_vydavkov: 100_000,
           rocne_naklady: 20_000,
           schvaleny_rozpocet: 120_000,
           schvalene_rocne_naklady: 25_000)
  end

  let(:metais_project) { double(Datahub::Metais::Project, latest_version: latest_version, uuid: 'uuid1') }
  let(:project) { double(Metais::Project) }
  let(:project_origin) { instance_double(Metais::ProjectOrigin, save!: true) }

  before do
    allow(Metais::ProjectOrigin).to receive(:find_or_initialize_by).and_return(project_origin)

    allow(Metais::OriginType).to receive(:find_by).with(name: 'MetaIS').and_return(double('OriginType'))
    allow(Datahub::Metais::CodelistProjectState).to receive(:find_by).with(code: 'Active').and_return(double('ProjectState', nazov: 'Active State'))
    allow(Datahub::Metais::CodelistProjectPhase).to receive(:find_by).with(code: 'Phase 1').and_return(double('ProjectPhase', nazov: 'Phase 1'))
    allow(Datahub::Metais::CodelistProgram).to receive(:find_by).with(uuid: 'Program UUID').and_return(double('Program', nazov: 'Program Name'))

    allow(project_origin).to receive(:title=)
    allow(project_origin).to receive(:description=)
    allow(project_origin).to receive(:status=)
    allow(project_origin).to receive(:phase=)
    allow(project_origin).to receive(:guarantor=)
    allow(project_origin).to receive(:metais_created_at=)
    allow(project_origin).to receive(:start_date=)
    allow(project_origin).to receive(:end_date=)
    allow(project_origin).to receive(:status_change_date=)
    allow(project_origin).to receive(:finance_source=)
    allow(project_origin).to receive(:investment=)
    allow(project_origin).to receive(:operation=)
    allow(project_origin).to receive(:approved_investment=)
    allow(project_origin).to receive(:approved_operation=)

    allow(Metais::ProjectDataExtractionJob).to receive(:perform_later)
    allow(Metais::SyncProjectSuppliersJob).to receive(:perform_later)
    allow(Metais::SyncProjectDocumentsJob).to receive(:perform_later)
    allow(Metais::SyncProjectEventsJob).to receive(:perform_later)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'updates or creates a ProjectOrigin and enqueues subsequent jobs' do
    Metais::SyncProjectJob.perform_now(project, metais_project)

    expect(enqueued_jobs).to include(
                               a_hash_including(
                                 job: Metais::ProjectDataExtractionJob,
                                 args: [metais_project.uuid],
                                 queue: 'metais_data_extraction'
                               )
                             )
    expect(Metais::SyncProjectSuppliersJob).to have_received(:perform_later).with(project_origin, metais_project)
    expect(Metais::SyncProjectDocumentsJob).to have_received(:perform_later).with(project_origin, metais_project)
    expect(Metais::SyncProjectEventsJob).to have_received(:perform_later).with(project_origin, metais_project)
  end
end
