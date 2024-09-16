class Metais::ProjectsController < ApplicationController
  def index
    @guarantor_data = Metais::ProjectOrigin.guarantor_data
    @status_data = Metais::ProjectOrigin.status_data
    @evaluation_counts = Metais::Project.evaluation_counts
        
    per_page = 25
    page = params[:page] || 1

    
    distinct_projects_subquery = Metais::Project
                                    .joins(:project_origins)
                                    .joins("JOIN (SELECT project_id, MAX(origin_type_id) AS max_origin_type_id 
                                                  FROM metais.project_origins 
                                                  GROUP BY project_id) 
                                            po_max 
                                            ON metais.projects.id = po_max.project_id 
                                            AND metais.project_origins.origin_type_id = po_max.max_origin_type_id")
                                    .select('DISTINCT metais.projects.id')
    
      @projects = Metais::Project
                   .joins(:project_origins)
                   .joins("JOIN (SELECT project_id, MAX(origin_type_id) AS max_origin_type_id 
                                 FROM metais.project_origins 
                                 GROUP BY project_id) 
                           po_max 
                           ON metais.projects.id = po_max.project_id 
                           AND metais.project_origins.origin_type_id = po_max.max_origin_type_id")
                   .where(id: distinct_projects_subquery)
                   .select('metais.projects.*, project_origins.approved_investment, project_origins.investment')
    
    if params[:guarantor].present?
      @projects = @projects.where('project_origins.guarantor = ?', params[:guarantor])
    end

    if params[:title].present?
      project_ids = @projects.where('project_origins.title ILIKE ?', "%#{params[:title]}%").distinct.pluck(:id)
      @projects = @projects.where(id: project_ids)
    end

    if params[:status].present?
      @projects = @projects.where('project_origins.status = ?', params[:status])
    end

    if params[:code].present?
      @projects = @projects.where('code ILIKE ?', "%#{params[:code]}%")
    end

    if params[:min_price].present?
      min_price = params[:min_price].to_f
      @projects = @projects.where(
        'COALESCE(NULLIF(metais.project_origins.approved_investment, 0), metais.project_origins.investment, 0) >= ?', min_price
      )
    end
    
    if params[:max_price].present?
      max_price = params[:max_price].to_f
      @projects = @projects.where(
        'COALESCE(NULLIF(metais.project_origins.approved_investment, 0), metais.project_origins.investment, 0) <= ?', max_price
      )
    end

    if params[:has_evaluation].present?
      @projects = Metais::Project.where(id: @projects.select { |project|
        evaluations = project.evaluations
        if params[:has_evaluation] == 'yes'
          evaluations.exists?
        else
          evaluations.empty?
        end
      }.map(&:id))
    end

    if params[:sort].present?
      case params[:sort]
      when 'alpha'
        if params[:sort_direction].present?
          sort_direction = params[:sort_direction].upcase == 'ASC' ? 'ASC' : 'DESC'
        else
          sort_direction = 'DESC'
        end
        @projects = @projects.order("metais.project_origins.title #{sort_direction}")
      when 'date'
        if params[:sort_direction].present?
          sort_direction = params[:sort_direction].upcase == 'ASC' ? 'ASC' : 'DESC'
        else
          sort_direction = 'DESC'
        end
        @projects = @projects.order("metais.project_origins.metais_created_at #{sort_direction}")
      when 'price'
        if params[:sort_direction].present?
          sort_direction = params[:sort_direction].upcase == 'ASC' ? 'ASC' : 'DESC'
        else
          sort_direction = 'DESC'
        end
        @projects = @projects.order("COALESCE(NULLIF(metais.project_origins.approved_investment, 0), 
                                            NULLIF(metais.project_origins.investment, 0), 
                                            0) #{sort_direction} NULLS FIRST")

      else
        if params[:sort_direction].present?
          sort_direction = params[:sort_direction].upcase == 'ASC' ? 'ASC' : 'DESC'
        else
          sort_direction = 'DESC'
        end
        @projects = @projects.select("distinct on (updated_at) projects.*").order("updated_at #{sort_direction}")
      end
    end

    @projects = @projects.page(page).per(per_page)
  end

  def show
    @project = Metais::Project.find(params[:id])
    @project_info = @project.get_project_origin_info
    @project_origins = @project.project_origins

    @assumption_events = []
    @real_events = []
    @project_origins.each do |project_origin|
      @assumption_events.concat(project_origin.events.where(event_type: Metais::ProjectEventType.find_by(name: 'Predpoklad')))
      @real_events.concat(project_origin.events.where(event_type: Metais::ProjectEventType.find_by(name: 'Realita')))
    end
    @assumption_events.sort_by! { |event| event.date }
    @real_events.sort_by! { |event| event.date }

    @all_suppliers = []
    @project_origins.each do |project_origin|
      @all_suppliers.concat(project_origin.suppliers)
    end
    @all_suppliers.sort_by! { |event| event.date || Time.zone.parse('2999-12-31')}

    @all_links = []
    @project_origins.each do |project_origin|
      @all_links.concat(project_origin.links)
    end

    @all_documents = @project_origins.flat_map(&:documents)
    @documents_grouped_by_description = @all_documents.group_by(&:description)

    @project_origin = @project.project_origins.first
    @project_origin = Metais::ProjectOrigin.includes(:documents, :suppliers).find(@project_origin.id)
  end
end
