require 'rails_helper'

RSpec.describe SyncTopicJob, type: :job do
  it 'loads current version of topic into page and revision', vcr: true do
    subject.perform(4034)

    expect(Page.first).to have_attributes(
      id: 4034
    )

    expect(Page.first.revisions.first).to have_attributes(
      version: 9
    )
  end
end
