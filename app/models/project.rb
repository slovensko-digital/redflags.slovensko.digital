# == Schema Information
#
# Table name: projects
#
#  id                    :integer          not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Project < ApplicationRecord
  has_many :phases

  def has_published_phases?
    phases.any? { |phase| phase.published_revision.present? }
  end

=begin
  has_many :revisions, class_name: 'PhaseRevision'

  has_many :published_revisions, -> { where(published: true) }, class_name: 'PhaseRevision'

  scope :published, -> { where.not(projects: { published_revision_id: nil }) }
  scope :with_tag, -> (tag) { joins(published_revision: :revision).where("? = ANY(revisions.tags)", tag) }
=end
end
