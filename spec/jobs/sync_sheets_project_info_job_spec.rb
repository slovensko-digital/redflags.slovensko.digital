require 'rails_helper'

RSpec.describe SyncSheetsProjectInfoJob, type: :job do
  describe '#perform' do
    let(:phase) { instance_double(Phase, nil?: false) }
    let(:page_attributes) do
      {
        phase: phase,
        build_unpublish_updates: 'unpublish_updates',
        build_publish_updates: 'publish_updates'
      }
    end

    let(:unpublished_page) { instance_double(Page, page_attributes.merge(published?: false, id: 1)) }
    let(:published_page) { instance_double(Page, page_attributes.merge(published?: true, id: 2, published_revision: instance_double(Revision, phase_revision: instance_double(PhaseRevision)))) }

    let(:relation) { double('ActiveRecord::Relation') }
    let(:jobs) { [UpdateMultipleSheetColumnsJob, ExportTopicIntoSheetJob] }

    before do
      allow(Page).to receive(:where).and_return(relation)
      jobs.each do |job|
        allow(job).to receive(:set).and_return(job)
        allow(job).to receive(:perform_later)
      end
    end

    it 'processes published pages' do
      allow(relation).to receive(:not).and_return([published_page])

      SyncSheetsProjectInfoJob.perform_now

      expect(UpdateMultipleSheetColumnsJob).to have_received(:perform_later).with(published_page.id, 'publish_updates')
      expect(ExportTopicIntoSheetJob).to have_received(:perform_later).with(published_page.published_revision.phase_revision)
    end

    it 'processes unpublished pages' do
      allow(relation).to receive(:not).and_return([unpublished_page])

      SyncSheetsProjectInfoJob.perform_now

      expect(UpdateMultipleSheetColumnsJob).to have_received(:perform_later).with(unpublished_page.id, 'unpublish_updates')
      expect(ExportTopicIntoSheetJob).not_to have_received(:perform_later)
    end
  end
end