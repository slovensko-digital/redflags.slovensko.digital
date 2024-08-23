require 'rails_helper'

RSpec.describe Metais::SyncProjectEventsJob, type: :job do
  include ActiveJob::TestHelper

  let(:project_origin) { instance_double('Metais::ProjectOrigin') }
  let(:metais_project) { instance_double('Metais::Project', latest_version: 'v1') }
  let(:origin_type) { instance_double('Metais::OriginType') }
  let(:event_type) { instance_double('Metais::ProjectEventType') }

  let(:status_change) do
    instance_double('Datahub::Metais::ProjectChange',
                    field: 'status',
                    created_at: Time.now,
                    new_value: 'new_status',
                    old_value: 'old_status')
  end

  let(:phase_change) do
    instance_double('Datahub::Metais::ProjectChange',
                    field: 'faza_projektu',
                    created_at: Time.now,
                    new_value: 'new_phase',
                    old_value: 'old_phase')
  end

  let(:codelist_project_state_old) { instance_double('Datahub::Metais::CodelistProjectState', nazov: 'Old Status') }
  let(:codelist_project_state_new) { instance_double('Datahub::Metais::CodelistProjectState', nazov: 'New Status') }
  let(:codelist_project_phase_old) { instance_double('Datahub::Metais::CodelistProjectPhase', nazov: 'Old Phase') }
  let(:codelist_project_phase_new) { instance_double('Datahub::Metais::CodelistProjectPhase', nazov: 'New Phase') }

  before do
    allow(Metais::OriginType).to receive(:find_by).with(name: 'MetaIS').and_return(origin_type)
    allow(Metais::ProjectEventType).to receive(:find_by).with(name: 'Realita').and_return(event_type)

    allow(Datahub::Metais::ProjectChange).to receive(:where).with(project_version: metais_project.latest_version).and_return([status_change, phase_change])

    allow(Datahub::Metais::CodelistProjectState).to receive(:find_by).with(code: 'old_status').and_return(codelist_project_state_old)
    allow(Datahub::Metais::CodelistProjectState).to receive(:find_by).with(code: 'new_status').and_return(codelist_project_state_new)
    allow(Datahub::Metais::CodelistProjectPhase).to receive(:find_by).with(code: 'old_phase').and_return(codelist_project_phase_old)
    allow(Datahub::Metais::CodelistProjectPhase).to receive(:find_by).with(code: 'new_phase').and_return(codelist_project_phase_new)

    @project_event_double = instance_double('Metais::ProjectEvent')
    allow(Metais::ProjectEvent).to receive(:find_or_initialize_by).and_return(@project_event_double)
    allow(@project_event_double).to receive(:save!)
  end

  describe '#perform' do
    it 'processes all changes and creates events correctly' do
      described_class.perform_now(project_origin, metais_project)

      expect(Metais::ProjectEvent).to have_received(:find_or_initialize_by).with(
        project_origin: project_origin,
        origin_type: origin_type,
        event_type: event_type,
        name: 'New Status',
        value: "Stav projektu bol zmenený z\n        old status na\n        new status",
        date: status_change.created_at
      ).once

      expect(Metais::ProjectEvent).to have_received(:find_or_initialize_by).with(
        project_origin: project_origin,
        origin_type: origin_type,
        event_type: event_type,
        name: 'New Phase',
        value: "Fáza projektu bola zmenená z\n        old phase na\n        new phase",
        date: phase_change.created_at
      ).once

      expect(@project_event_double).to have_received(:save!).twice
    end
  end
end
