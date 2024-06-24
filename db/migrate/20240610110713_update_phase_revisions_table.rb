class UpdatePhaseRevisionsTable < ActiveRecord::Migration[5.1]
  def up
    add_reference :phase_revisions, :phase, index: true, foreign_key: true

    project_to_phase = {}

    Phase.reset_column_information

    PhaseRevision.select(:project_id).distinct.find_each do |phase_revision|
      project_id = phase_revision.project_id
      next if project_to_phase[project_id]

      phase = Phase.find_or_create_by!(
        project_id: project_id,
        phase_type: PhaseType.find_by!(name: 'Prípravná fáza')
      )
      project_to_phase[project_id] = phase.id
    end

    PhaseRevision.find_each do |phase_revision|
      phase_revision.update!(phase_id: project_to_phase[phase_revision.project_id])
    end

    remove_reference :phase_revisions, :project, index: true, foreign_key: true
  end

  def down
    add_reference :phase_revisions, :project, index: true, foreign_key: true

    remove_reference :phase_revisions, :phase, index: true, foreign_key: true

    PhaseRevision.find_each do |phase_revision|
      phase_revision.update!(project_id: Phase.find(phase_revision.phase_id).project_id)
    end
  end
end
