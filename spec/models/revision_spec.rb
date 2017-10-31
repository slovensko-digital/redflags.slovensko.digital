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

require 'rails_helper'

RSpec.describe Revision, type: :model do
end
