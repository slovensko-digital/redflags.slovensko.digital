# == Schema Information
#
# Table name: pages
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  published_revision_id :integer
#  latest_revision_id    :integer
#
# Foreign Keys
#
#  fk_rails_...  (latest_revision_id => revisions.id)
#  fk_rails_...  (published_revision_id => revisions.id)
#

require 'rails_helper'

RSpec.describe Page, type: :model do
  describe '#publish?' do
    it 'returns true if the page is published' do
      page = create(:page, :published)

      expect(page.published?).to eq(true)
    end

    it 'returns false if the page is unpublished' do
      page = create(:page, :unpublished)

      expect(page.published?).to eq(false)
    end
  end

  describe '#synced?' do
    it 'returns true if the page is synced' do
      page = create(:page, :synced)

      expect(page.synced?).to eq(true)
    end

    it 'returns false if the page is unsynced' do
      page = create(:page, :unsynced)

      expect(page.synced?).to eq(false)
    end
  end
end
