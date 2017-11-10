class Admin::ProjectsController < AdminController
  before_action :load_project, only: [:update]

  def update
    @project.update!(project_params)
    redirect_to admin_page_path(@project.page)
  end

  private

  def load_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:category)
  end
end
