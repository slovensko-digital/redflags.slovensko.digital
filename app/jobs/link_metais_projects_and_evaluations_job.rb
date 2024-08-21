class LinkMetaisProjectsAndEvaluationsJob < ApplicationJob
  queue_as :default

  def perform
    Metais::Project.find_each do |metais_project|
      code = metais_project.code

      evaluation = Project.find_by(metais_code: code)

      CombinedProject.create!(
        evaluation: evaluation,
        metais_project: metais_project
      )
    end
  end
end
