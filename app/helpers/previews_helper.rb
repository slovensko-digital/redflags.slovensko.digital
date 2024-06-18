module PreviewsHelper
  def page_preview?(page)
    page.revisions.any?
  end

  def revision_preview?(revision)
    return true unless revision.page.project.present?

    revision.total_score.present? && !revision.total_score_percentage.nan?
  end
end
