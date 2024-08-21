class Metais::DailySyncProjectsJob < ApplicationJob
  queue_as :metais

  def perform
    Datahub::Metais::Project.where('updated_at > ?', Time.now - 1.day).find_each do |metais_project|
      project = Metais::Project.find_or_initialize_by(code: metais_project.latest_version.kod_metais,
                                                      uuid: metais_project.uuid)
      project.save!

      Metais::SyncProjectJob.perform_later(project, metais_project)
    end
  end
end
