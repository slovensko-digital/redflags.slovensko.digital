# == Schema Information
#
# Table name: revision_ratings
#
#  id                :bigint           not null, primary key
#  rating_type_id    :bigint           not null
#  score             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  revision_id       :bigint
#
# Indexes
#
#  index_revision_ratings_on_rating_type_id  (rating_type_id)
#  index_revision_ratings_on_revision_id     (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (rating_type_id => rating_types.id)
#  fk_rails_...  (revision_id => revisions.id)
#

class RevisionRating < ApplicationRecord
  belongs_to :revision
  belongs_to :rating_type
end
