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

  def self.filtered_projects(selected_tag, sort_param)

    case sort_param
    when 'newest'
      projects = Project.joins(phases: :published_revision)
                         .select('projects.*, MAX(phase_revisions.published_at) AS newest_published_at')
                         .group('projects.id')
                         .order('newest_published_at DESC')
    when 'oldest'
      projects = Project.joins(phases: :published_revision)
                         .select('projects.*, MIN(phase_revisions.published_at) AS oldest_published_at')
                         .group('projects.id')
                         .order('oldest_published_at')
    when 'alpha', 'alpha_reverse'
      projects = Project.joins(phases: :published_revision)
                   .select('DISTINCT ON (projects.id) projects.*, LOWER(phase_revisions.title) AS alpha_title')
                   .order('projects.id, alpha_title')
      projects = projects.sort_by(&:alpha_title)
      projects = projects.reverse if sort_param == 'alpha_reverse'
    when 'preparation_lowest'
      projects = Project.joins(phases: :published_revision)
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Prípravná fáza' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end.reverse
    when 'preparation_highest'
      projects = Project.joins(phases: :published_revision)
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Prípravná fáza' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end
    when 'product_lowest'
      projects = Project.joins(phases: :published_revision)
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Fáza produkt' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end.reverse
    when 'product_highest'
      projects = Project.joins(phases: :published_revision)
                        .where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') })
                        .distinct
      projects = projects.sort_by do |project|
        phase_prep = project.phases.find { |p| p.phase_type.name == 'Fáza produkt' }
        phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
      end
    else
      projects = Project.joins(phases: :published_revision)
                        .distinct

      if ProjectsHelper::ALLOWED_TAGS.keys.include?(selected_tag)
        projects = Project.joins(phases: :published_revision)
                          .where(phase_revisions: { tags: selected_tag })
      end

      projects = projects.sort_by do |project|
        max_rating = project.phases.map { |p| p.published_revision&.aggregated_rating }.compact.max
        max_rating
      end
    end

    projects
  end
end
