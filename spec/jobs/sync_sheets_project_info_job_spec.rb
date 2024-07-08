require 'rails_helper'

RSpec.describe SyncSheetsProjectInfoJob, type: :job do
  describe '#perform' do
    let(:mock_phase) { instance_double(Phase, present?: true) }
    let(:phase_revision) { instance_double(PhaseRevision) }
    let(:published_revision) { instance_double(Revision, phase_revision: phase_revision) }
    let(:unpublished_page) { instance_double(Page, published?: false, phase: mock_phase, id: 1, build_unpublish_updates: 'unpublish_updates') }
    let(:published_page) { instance_double(Page, published?: true, phase: mock_phase, id: 2, published_revision: published_revision, build_publish_updates: 'publish_updates') }

    before do
      allow(UpdateMultipleSheetColumnsJob).to receive(:set).and_return(UpdateMultipleSheetColumnsJob)
      allow(UpdateMultipleSheetColumnsJob).to receive(:perform_later)
      allow(ExportTopicIntoSheetJob).to receive(:set).and_return(ExportTopicIntoSheetJob)
      allow(ExportTopicIntoSheetJob).to receive(:perform_later)
    end

    it 'calls UpdateMultipleSheetColumnsJob and ExportTopicIntoSheetJob for published pages' do
      allow(Page).to receive(:all).and_return([published_page])

      SyncSheetsProjectInfoJob.perform_now

      expect(UpdateMultipleSheetColumnsJob).to have_received(:perform_later).with(published_page.id, 'publish_updates')
      expect(ExportTopicIntoSheetJob).to have_received(:perform_later).with(phase_revision)
    end

    it 'calls UpdateMultipleSheetColumnsJob for unpublished pages' do
      allow(Page).to receive(:all).and_return([unpublished_page])

      SyncSheetsProjectInfoJob.perform_now

      expect(UpdateMultipleSheetColumnsJob).to have_received(:perform_later).with(unpublished_page.id, 'unpublish_updates')
      expect(ExportTopicIntoSheetJob).not_to have_received(:perform_later)
    end
  end
end