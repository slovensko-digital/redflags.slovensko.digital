class Metais::ProjectsController < ApplicationController
  def index
    per_page = 25
    page = params[:page] || 1

    @projects = Metais::Project.all

    if params[:guarantor].present? || params[:title].present? || params[:status].present? || params[:code].present? || params[:min_price].present? || params[:max_price].present? || params[:sort].present?
      @projects = @projects.joins(:project_origins)
    end

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
      @projects = @projects.where('code = ?', params[:code])
    end

    if params[:min_price].present?
      @projects = @projects.where('project_origins.investment >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @projects = @projects.where('project_origins.investment <= ?', params[:max_price])
    end

    if params[:has_evaluation].present?
      @projects = @projects.joins(:combined_projects)

      if params[:has_evaluation] == 'yes'
        @projects = @projects.where.not(combined_projects: { evaluation_id: nil })
      elsif params[:has_evaluation] == 'no'
        @projects = @projects.where(combined_projects: { evaluation_id: nil })
      end
    end

    case params[:sort]
    when 'alpha'
      @projects = @projects.order('project_origins.title ASC')
      @projects = @projects.distinct.select("metais.projects.*, project_origins.title")
    when 'date'
      @projects = @projects.order('project_origins.metais_created_at ASC')
      @projects = @projects.distinct.select("metais.projects.*, project_origins.metais_created_at")

    when 'price'
      @projects = @projects.order('project_origins.investment ASC')
      @projects = @projects.distinct.select("metais.projects.*, project_origins.investment")

    else
      @projects = @projects.order(updated_at: :desc)
      @projects = @projects.distinct.select("metais.projects.*")

    end

    @projects = @projects.page(page).per(per_page)
  end

  def show
    @project = Metais::Project.find(params[:id])
    @combined_project = CombinedProject.find_by(metais_project_id: @project.id)
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

    @project_origin = @project.project_origins.first
    @project_origin = Metais::ProjectOrigin.includes(:documents, :suppliers).find(@project_origin.id)
  end
end
