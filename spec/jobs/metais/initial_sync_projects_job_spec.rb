require 'rails_helper'

RSpec.describe Metais::InitialSyncProjectsJob, type: :job do
  let(:latest_version) { double('LatestVersion', kod_metais: 'code1') }
  let(:datahub_project) { instance_double(Datahub::Metais::Project, uuid: 'uuid1', latest_version: latest_version) }
  let(:metais_project) { instance_double(Metais::Project, save!: true) }

  before do
    allow(Datahub::Metais::Project).to receive(:find_each).and_yield(datahub_project)
    allow(Metais::Project).to receive(:find_or_initialize_by).with(code: 'code1', uuid: 'uuid1').and_return(metais_project)
    allow(Metais::SyncProjectJob).to receive(:perform_later)
  end

  it 'processes each Datahub project and enqueues a SyncProjectJob' do
    Metais::InitialSyncProjectsJob.perform_now

    expect(Datahub::Metais::Project).to have_received(:find_each)
    expect(Metais::Project).to have_received(:find_or_initialize_by).with(code: 'code1', uuid: 'uuid1')
    expect(metais_project).to have_received(:save!)
    expect(Metais::SyncProjectJob).to have_received(:perform_later).with(metais_project, datahub_project)
  end
end
