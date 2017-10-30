# == Schema Information
#
# Table name: project_revision_ratings
#
#  id                  :integer          not null, primary key
#  project_revision_id :integer          not null
#  rating_type_id      :integer          not null
#  score               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_project_revision_ratings_on_project_revision_id  (project_revision_id)
#  index_project_revision_ratings_on_rating_type_id       (rating_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_revision_id => project_revisions.id)
#  fk_rails_...  (rating_type_id => rating_types.id)
#

class ProjectRevisionRating < ApplicationRecord
  belongs_to :project_revision
  belongs_to :rating_type
end
