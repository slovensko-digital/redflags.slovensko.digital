# == Schema Information
#
# Table name: revisions
#
#  id         :integer          not null, primary key
#  page_id    :integer          not null
#  version    :integer          not null
#  raw        :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string           not null
#  tags       :string           default([]), is an Array
#
# Indexes
#
#  index_revisions_on_page_id              (page_id)
#  index_revisions_on_page_id_and_version  (page_id,version) UNIQUE
#  index_revisions_on_tags                 (tags)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#

class Revision < ApplicationRecord
  belongs_to :page

  after_save :schedule_sync_project_job # TODO: move to domain events and pubsub

  def body_html
    substitue_iframes raw['post_stream']['posts'].first['cooked']
  end

  def published?
    page.published_revision == self
  end

  def latest?
    page.latest_revision == self
  end

  private

  def schedule_sync_project_job
    SyncRevisionJob.perform_later(self)
  end

  def substitue_iframes(body)
    doc = Nokogiri::HTML.parse(body)
    doc.css('iframe[src*="bi.ekosystem.slovensko.digital"]').each_with_index do |iframe, index|
      iframe['id'] = "iframe_#{index}"
      iframe.add_previous_sibling('<script src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/4.3.6/iframeResizer.min.js"></script>')
      iframe.add_next_sibling("<script>iFrameResize({}, '#iframe_#{index}')</script>")
    end
    doc.to_html
  end
end
