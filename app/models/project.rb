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
  has_and_belongs_to_many :metais_projects, class_name: 'Metais::Project',
                                                             join_table: 'public.projects_metais_projects',
                                                             foreign_key: 'project_id',
                                                             association_foreign_key: 'metais_project_id'

  def has_published_phases?
    phases.any? { |phase| phase.published_revision.present? }
  end

  def self.filtered_and_sorted_projects(params)
    per_page = 25
    page = params[:page] || 1

    projects = Project.joins(phases: :published_revision)

    if params[:title].present?
      projects = projects.where('phase_revisions.title ILIKE ?', "%#{params[:title]}%")
    end

    params[:sort] = 'date' unless params[:sort].present?
    sort_direction = params[:sort_direction]&.upcase == 'ASC' ? 'ASC' : 'DESC'
    projects = case params[:sort]
                when 'alpha'
                  projects = projects.select('DISTINCT ON (projects.id) projects.*, LOWER(phase_revisions.title) AS alpha_title')
                                      .order("projects.id, alpha_title")
                  projects = projects.sort_by(&:alpha_title)
                  projects = projects.reverse if sort_direction == 'DESC'
                  projects
                when 'date'
                  if sort_direction == 'ASC'
                    projects = projects.select("projects.*, MIN(phase_revisions.published_at) AS oldest_published_at").group("projects.id")
                                        .order("oldest_published_at")
                  elsif sort_direction == 'DESC'
                    projects = projects.select('projects.*, MAX(phase_revisions.published_at) AS newest_published_at').group('projects.id')
                                        .order('newest_published_at DESC')
                  end
                when 'preparation'
                  if sort_direction == 'ASC'
                    projects = projects.where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') }).distinct
                    projects = projects.sort_by do |project|
                      phase_prep = project.phases.find { |p| p.phase_type.name == 'Prípravná fáza' }
                      phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
                    end.reverse
                  elsif sort_direction == 'DESC'
                    projects = projects.where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') }).distinct
                    projects = projects.sort_by do |project|
                      phase_prep = project.phases.find { |p| p.phase_type.name == 'Prípravná fáza' }
                      phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
                    end
                  end
                when 'product'
                  if sort_direction == 'ASC'
                    projects = projects.where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') }).distinct
                    projects = projects.sort_by do |project|
                      phase_prep = project.phases.find { |p| p.phase_type.name == 'Fáza produkt' }
                      phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
                    end.reverse

                  elsif sort_direction == 'DESC'
                    projects = projects.where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') }).distinct
                    projects = projects.sort_by do |project|
                      phase_prep = project.phases.find { |p| p.phase_type.name == 'Fáza produkt' }
                      phase_prep ? (phase_prep.published_revision.aggregated_rating) : 0
                    end
                  end
                end

    projects = Kaminari.paginate_array(projects).page(page).per(per_page)
    projects
  end
end
