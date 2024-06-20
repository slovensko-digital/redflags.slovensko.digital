require 'rails_helper'

RSpec.describe SyncCategoryTopicsJob, type: :job do
  let(:sync_topic_job) { spy }

  it 'schedules topic sync jobs for all topics in category', vcr: true do
    subject.perform('red-flags', sync_topic_job: sync_topic_job)

    expect(sync_topic_job).to have_received(:perform_later).with(nil, 4034)
    expect(sync_topic_job).to have_received(:perform_later).with(nil, 4334)
    expect(sync_topic_job).to have_received(:perform_later).with(nil, 4035)
  end

  it 'schedules next topic page when listing too long', vcr: true do
    expect(SyncCategoryTopicsJob).to receive(:perform_later).with('statne-projekty', 1)

    subject.perform('statne-projekty')
  end
end
