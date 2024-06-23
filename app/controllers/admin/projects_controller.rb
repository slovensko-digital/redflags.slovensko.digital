class Admin::ProjectsController < AdminController
  before_action :load_project

  private

  def load_project
    @project = Project.find(params[:id])
  end
end
