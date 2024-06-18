# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Project < ApplicationRecord
  has_many :pages

  has_many :revisions, class_name: 'ProjectRevision'

  has_many :published_revisions, -> { where(published: true) }, class_name: 'ProjectRevision'

  scope :published, -> { where.not(projects: { published_revision_id: nil }) }
  scope :with_tag, -> (tag) { joins(published_revision: :revision).where("? = ANY(revisions.tags)", tag) }
end
