class ProjectsController < ApplicationController

  def index
    @selected_tag = params[:tag]
    @projects = Project.filtered_projects(@selected_tag, params[:sort])
  end
end
