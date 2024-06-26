class AddPhaseToPages < ActiveRecord::Migration[5.1]
  def change
    add_reference :pages, :phase, index:true ,foreign_key: true

    Page.reset_column_information
    Project.find_each do |project|
      project.phases.find_each do |phase|
        phase.revisions.find_each do |phase_revision|
          phase_revision.revision.page.update!(phase_id: phase.id)
        end
      end
    end
  end
end
