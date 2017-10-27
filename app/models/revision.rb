class Revision < ApplicationRecord
  belongs_to :page

  def published?
    page.published_revision == self
  end

  def latest?
    page.latest_revision == self
  end
end
