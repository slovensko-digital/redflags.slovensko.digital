class Admin::Metais::ProjectsController < AdminController
  def index
    @guarantor_counts = Metais::ProjectOrigin.guarantor_counts
    @unique_guarantors = Metais::ProjectOrigin.unique_guarantors
    @status_counts = Metais::ProjectOrigin.status_counts
    @unique_statuses = Metais::ProjectOrigin.unique_statuses
    @evaluation_counts = Metais::Project.evaluation_counts
    
    @projects = Metais::Project.filtered_and_sorted_projects(params)
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

  def run_ai_extraction
    @project = Metais::Project.find(params[:id])
    Metais::ProjectDataExtractionJob.perform_later(@project.uuid)

    redirect_to admin_metais_project_path @project
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
