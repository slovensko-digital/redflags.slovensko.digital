module PreviewsHelper
  def page_preview?(page)
    page.revisions.any?
  end

  def revision_preview?(revision)
    return true unless Project.exists?(page: revision.page)
    project_revision = ProjectRevision.where(revision: revision).first
    project_revision && !project_revision.total_score_percentage.nan?
  end
end
