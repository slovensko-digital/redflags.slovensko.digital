require 'rails_helper'

RSpec.describe UpdateMultipleSheetColumnsJob, type: :job do
  let(:page_id) { 'some_page_id' }
  let(:updates) do
    [
      { column_names: ['name1', 'name2'], page_type: 'type1', published_value: 'val1' },
      { column_names: ['name3', 'name4'], page_type: 'type2', published_value: 'val2' }
    ]
  end

  before do
    allow(UpdateSheetValueJob).to receive(:perform_now)
  end

  it 'tasks are enqueued and update is performed' do
    described_class.perform_now(page_id, updates)

    expect(UpdateSheetValueJob).to have_received(:perform_now).with(
      page_id,
      updates[0][:column_names],
      updates[0][:page_type],
      updates[0][:published_value]
    )
    expect(UpdateSheetValueJob).to have_received(:perform_now).with(
      page_id,
      updates[1][:column_names],
      updates[1][:page_type],
      updates[1][:published_value]
    )
    expect(UpdateSheetValueJob).to have_received(:perform_now).twice
  end
end