require 'rails_helper'

RSpec.describe SyncCategoryTopicsJob, type: :job do
  let(:sync_topic_job) { spy }

  it 'schedules topic sync jobs for all topics in category', vcr: true do
    subject.perform('red-flags', sync_topic_job)

    expect(sync_topic_job).to have_received(:perform_later).with(4034)
    expect(sync_topic_job).to have_received(:perform_later).with(4334)
    expect(sync_topic_job).to have_received(:perform_later).with(4035)
  end

  pending 'schedules next topic page when listing too long'
end
