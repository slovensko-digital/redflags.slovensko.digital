class Admin::Metais::ProjectsController < AdminController
  def index
    @guarantor_counts = Metais::ProjectOrigin.guarantor_counts
    @unique_guarantors = Metais::ProjectOrigin.unique_guarantors
    @status_counts = Metais::ProjectOrigin.status_counts
    @unique_statuses = Metais::ProjectOrigin.unique_statuses
    @evaluation_counts = Metais::Project.evaluation_counts

    @projects = Metais::Project.filtered_and_sorted_projects(params)
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

    redirect_to admin_metais_project_path @project, notice: 'Projekt bol zaradený na spracovanie.'
  end
end
