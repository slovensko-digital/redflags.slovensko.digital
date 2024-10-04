class LinkMetaisProjectsAndEvaluationsJob < ApplicationJob
  queue_as :default

  def perform
    Project.find_each do |project|
      link_metais_project(project)
    end
  end

  private

  def link_metais_project(project)
    code = project.metais_code
    metais_project = Metais::Project.find_by(code: code)

    if metais_project.present? && !project.metais_projects.exists?(metais_project.id)
      project.metais_projects << metais_project
    end
  end
end