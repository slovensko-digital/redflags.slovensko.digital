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

  # The list of projects shows the published revision of every phase with its ratings. Load them for all
  # projects at once, not with a few queries per project.
  LIST_ASSOCIATIONS = { phases: [:phase_type, { published_revision: [:stage, { ratings: :rating_type }, { revision_for_list: :page }] }] }.freeze

  scope :with_published_phases, -> { joins(phases: :published_revision).preload(LIST_ASSOCIATIONS) }

  def has_published_phases?
    phases.any? { |phase| phase.published_revision.present? }
  end

  def self.filtered_projects(selected_tag, sort_param)

    case sort_param
    when 'newest'
      projects = Project.with_published_phases
                         .select('projects.*, MAX(phase_revisions.published_at) AS newest_published_at')
                         .group('projects.id')
                         .order('newest_published_at DESC')
    when 'oldest'
      projects = Project.with_published_phases
                         .select('projects.*, MIN(phase_revisions.published_at) AS oldest_published_at')
                         .group('projects.id')
                         .order('oldest_published_at')
    when 'alpha', 'alpha_reverse'
      projects = Project.with_published_phases
                   .select('DISTINCT ON (projects.id) projects.*, LOWER(phase_revisions.title) AS alpha_title')
                   .order('projects.id, alpha_title')
      projects = projects.sort_by(&:alpha_title)
      projects = projects.reverse if sort_param == 'alpha_reverse'
    when 'preparation_lowest'
      projects = Project.with_published_phases
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Prípravná fáza' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end.reverse
    when 'preparation_highest'
      projects = Project.with_published_phases
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Prípravná fáza' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end
    when 'product_lowest'
      projects = Project.with_published_phases
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Fáza produkt' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end.reverse
    when 'product_highest'
      projects = Project.with_published_phases
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Fáza produkt' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end
    else
      projects = Project.with_published_phases
                        .distinct

      if ProjectsHelper::ALLOWED_TAGS.keys.include?(selected_tag)
        # The tags are on the revision from Platforma, not on the revision of the phase.
        projects = Project.with_published_phases
                          .joins(phases: { published_revision: :revision })
                          .where('? = ANY(revisions.tags)', selected_tag)
                          .distinct
      end

      projects = projects.sort_by do |project|
        max_rating = project.phases.map { |p| p.published_revision&.aggregated_rating }.compact.max
        max_rating
      end
    end

    projects
  end
end
