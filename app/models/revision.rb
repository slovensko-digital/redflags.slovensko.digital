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
#
# Indexes
#
#  index_revisions_on_page_id              (page_id)
#  index_revisions_on_page_id_and_version  (page_id,version) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (page_id => pages.id)
#

class Revision < ApplicationRecord
  belongs_to :page

  after_save :schedule_sync_project_job # TODO: move to domain events and pubsub

  def body_html
    raw['post_stream']['posts'].first['cooked']
  end

  def project?
    ProjectRevision.exists?(revision: self)
  end

  def preview?
    project?
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
end
