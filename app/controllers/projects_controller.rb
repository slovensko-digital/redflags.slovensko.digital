class ProjectsController < ApplicationController
  
  def index
    @projects = Project.filtered_and_sorted_projects(params)
  end

end
