module PreviewsHelper
  def page_preview?(page)
    page.revisions.any?
  end

  def revision_preview?(revision)
    return true unless revision.phase_revision&.phase&.project.present?

    phase_revision = revision.phase_revision
    return false if phase_revision.nil?

    phase_revision.total_score.present? && !phase_revision.total_score_percentage.nan?
  end
end
