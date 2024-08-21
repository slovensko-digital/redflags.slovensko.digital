class Admin::Metais::ProjectsController < AdminController
  def index
    per_page = 25
    page = params[:page] || 1

    @projects = Metais::Project.all

    if filtering_params_present?
      @projects = @projects.joins(:project_origins)
    end

    if params[:guarantor].present?
      @projects = @projects.where('project_origins.guarantor = ?', params[:guarantor])
    end

    if params[:title].present?
      @projects = @projects.where('project_origins.title ILIKE ?', "%#{params[:title]}%")
    end

    if params[:status].present?
      @projects = @projects.where('project_origins.status = ?', params[:status])
    end

    if params[:code].present?
      @projects = @projects.where('metais.projects.code = ?', params[:code])
    end

    if params[:min_price].present?
      @projects = @projects.where('COALESCE(project_origins.investment, 0) >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @projects = @projects.where('COALESCE(project_origins.investment, 0) <= ?', params[:max_price])
    end

    case params[:change_date]
    when 'latest'
      @projects = @projects.order(updated_at: :desc)
    when 'oldest'
      @projects = @projects.order(updated_at: :asc)
    end

    @projects = @projects.distinct
    @projects = @projects.page(page).per(per_page)
  end


  def show
    @project = Metais::Project.find(params[:id])
  end
  def edit
    @project = Metais::Project.find(params[:id])
  end

  def update
    @project = Metais::Project.find(params[:id])
    if @project.update(project_params)
      redirect_to admin_metais_project_path(@project), notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def create_human_origin
    @project = Metais::Project.find(params[:id])
    origin_type = Metais::OriginType.find_by(name: 'Human')
    fail 'OriginType not found' unless origin_type

    human_origin = Metais::ProjectOrigin.find_or_initialize_by(project: @project, origin_type: origin_type)
    if human_origin.new_record?
      human_origin.title = @project.project_origins.first.title
      human_origin.save!
    end
    redirect_to edit_admin_metais_project_project_origin_path(@project, human_origin)
  end

  private

  def filtering_params_present?
    params[:guarantor].present? ||
      params[:title].present? ||
      params[:status].present? ||
      params[:code].present? ||
      params[:min_price].present? ||
      params[:max_price].present?
  end

  def project_params
    params.require(:project).permit(:guarantor, :finance_source, :status)
  end
end
