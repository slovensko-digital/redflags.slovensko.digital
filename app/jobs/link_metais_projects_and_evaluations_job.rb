class LinkMetaisProjectsAndEvaluationsJob < ApplicationJob
  queue_as :default

  def perform
    Project.find_each do |project|
      code = project.metais_code
      metais_project = Metais::Project.find_by(code: code)

      if metais_project.present?
        project.metais_projects << metais_project
      end
    end
  end
end