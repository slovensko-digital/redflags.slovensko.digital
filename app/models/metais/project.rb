# == Schema Information
#
# Table name: metais.projects
#
#  id                    :integer          not null, primary key
#  code                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::Project < ApplicationRecord
  has_many :project_origins, :class_name => 'Metais::ProjectOrigin'
  has_and_belongs_to_many :projects, class_name: 'Project',
                                     join_table: 'public.projects_metais_projects',
                                     foreign_key: 'metais_project_id',
                                     association_foreign_key: 'project_id'

  def evaluations
    ::Project.joins('''
    INNER JOIN "public"."projects_metais_projects" ON "public"."projects_metais_projects"."project_id" = "projects"."id"
    INNER JOIN "metais"."projects" AS "metais_projects" ON "metais_projects"."id" = "public"."projects_metais_projects"."metais_project_id"
    ''').where('projects_metais_projects.metais_project_id = ?', self.id)
  end

  def get_project_origin_info
    finance_source_mappings = {"Medzirezortný program 0EK Informačné technológie financované zo štátneho rozpočtu" => "Štátny rozpočet"}

    fields = %w[title status phase description guarantor project_manager start_date end_date
                finance_source investment operation approved_investment approved_operation
                supplier supplier_cin targets_text events_text documents_text links_text updated_at]

    origins = self.project_origins.sort_by { |origin| -origin.origin_type_id }

    project_info = OpenStruct.new
    fields.each do |field|
      origin = origins.detect { |origin| !origin.send(field).nil? }
      value = origin&.send(field)
      
      if field == 'finance_source' && value
        value = finance_source_mappings[value] || value
      end
      if value
        project_info.send("#{field}=", Metais::ValueWithOrigin.new(value, origin.origin_type_id))
      end
    end

    project_info
  end
  
  def self.evaluation_counts
    total_count = Metais::Project.count
    yes_count = Metais::Project
      .joins('INNER JOIN public.projects_metais_projects ON public.projects_metais_projects.metais_project_id = metais.projects.id')
      .distinct
      .count('metais.projects.id')
    no_count = total_count - yes_count
  
    { yes: yes_count, no: no_count }
  end
  
  def self.filtered_and_sorted_projects(params)
    per_page = 25
    page = params[:page] || 1

    ordered_project_origins = Metais::ProjectOrigin
      .select('project_id,
                COALESCE(NULLIF(max(approved_investment) FILTER (WHERE approved_investment IS NOT NULL), 0), 
                        NULLIF(max(investment) FILTER (WHERE investment IS NOT NULL), 0)) AS final_investment,
                max(title) FILTER (WHERE title IS NOT NULL) AS final_title,
                max(status) FILTER (WHERE status IS NOT NULL) AS final_status,
                max(guarantor) FILTER (WHERE guarantor IS NOT NULL) AS final_guarantor')
      .group('project_id')

    projects = Metais::Project.joins("INNER JOIN (#{ordered_project_origins.to_sql}) project_origins ON metais.projects.id = project_origins.project_id")

    projects = projects.where('project_origins.final_guarantor = ?', params[:guarantor]) if params[:guarantor].present?
    projects = projects.where('project_origins.final_status = ?', params[:status]) if params[:status].present?
    projects = projects.where('code ILIKE ?', "%#{params[:code]}%") if params[:code].present?
    projects = projects.where('project_origins.final_title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    projects = projects.where('project_origins.final_investment >= ?', params[:min_price].to_f) if params[:min_price].present?
    projects = projects.where('project_origins.final_investment <= ?', params[:max_price].to_f) if params[:max_price].present?

    if params[:has_evaluation].present?
      projects = projects.select { |project|
        params[:has_evaluation] == 'yes' ? project.evaluations.exists? : project.evaluations.empty?
      }
      projects = projects.map(&:id)
      projects = Metais::Project.where(id: projects)
    end

    if params[:sort].present?
      sort_direction = params[:sort_direction]&.upcase == 'ASC' ? 'ASC' : 'DESC'

      projects = case params[:sort]
                  when 'alpha'
                    projects.order("project_origins.final_title #{sort_direction}")
                  when 'date'
                    projects.order("metais.projects.updated_at #{sort_direction}")
                  when 'price'
                    projects.order("project_origins.final_investment #{sort_direction} NULLS #{sort_direction == 'ASC' ? 'FIRST' : 'LAST'}")
                  end
    else
      sort_direction = params[:sort_direction]&.upcase == 'ASC' ? 'ASC' : 'DESC'
      projects.order("metais.projects.updated_at #{sort_direction}")
    end

    projects.page(page).per(per_page)
  end
end
