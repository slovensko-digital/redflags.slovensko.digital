require 'rails_helper'

RSpec.describe SyncTopicJob, type: :job do
  it 'loads current version of topic into page and revision', vcr: true do
    subject.perform(4034)

    page = Page.first

    expect(page).to have_attributes(
      id: 4034,
      published_revision_id: nil,
      latest_revision_id: page.revisions.first.id
    )

    expect(page.revisions.count).to eq(1)
    expect(page.revisions.first).to have_attributes(
      title: 'O projekte Red Flags',
      tags: ['redflags'],
      version: 9
    )
  end
end
