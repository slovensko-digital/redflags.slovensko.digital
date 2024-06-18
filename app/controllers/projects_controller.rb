class ProjectsController < ApplicationController
  def show
    @project = Project.find_by!(id: params[:project_id])
    @revision_type = params[:revision_type]

    revision_types = { 'preparation' => 0, 'product' => 1 }
    page_type = revision_types[@revision_type]

    @project_revisions = @project.revisions.once_published.joins(revision: :page).where(pages: { page_type: page_type }).order(updated_at: :desc)
    @project_revision = @project.published_revisions.joins(revision: :page).find_by(pages: { page_type: page_type })

    if @project_revision
      @revision = @project_revision.revision
      @ratings_by_type = @revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'
    end
  end

  def pdf
    @project = Project.find_by!(id: params[:project_id])
    @revision_type = params[:revision_type]

    revision_types = { 'preparation' => 0, 'product' => 1 }
    page_type = revision_types[@revision_type]

    @project_revision = @project.published_revisions.joins(revision: :page).find_by(pages: { page_type: page_type })

    if @project_revision
      @revision = @project_revision.revision
      @ratings_by_type = @revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'

      respond_to do |format|
        format.html do
          render layout: "no_header_footer"
        end
      end
    end
  end

  def show_history
    @project = Project.find_by!(id: params[:id])
    @revision_type = params[:revision_type]

    revision_types = { 'preparation' => 0, 'product' => 1 }
    page_type = revision_types[@revision_type]

    page_id = params[:page_id]

    @project_revision = @project.revisions.once_published.joins(revision: :page).find_by(pages: { page_type: page_type, id: page_id })

    if @project_revision
      @revision = @project_revision.revision
      @ratings_by_type = @revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'

      render :show
    end
  end

  def index
    @selected_tag = params[:tag]
    @projects = Project.joins(:revisions)
                       .where(project_revisions: { published: true })
                       .distinct

    if ProjectsHelper::ALLOWED_TAGS.keys.include?(@selected_tag)
      @projects = @projects.joins(:published_revisions)
                           .where(revisions: { tags: @selected_tag })
    end

    case params[:sort]
    when 'newest'
      @projects = Project.all.sort_by { |project| project.published_revisions.maximum(:published_at) }.reverse
    when 'oldest'
      @projects = Project.all.sort_by { |project| project.published_revisions.maximum(:published_at) }
    when 'alpha'
      @projects = Project.joins(:published_revisions)
                         .select('DISTINCT ON (projects.id) projects.*, project_revisions.title AS rev_title')
                         .order('projects.id, rev_title')
      @projects = @projects.sort_by(&:rev_title)
    when 'alpha_reverse'
      @projects = Project.joins(:published_revisions)
                         .select('DISTINCT ON (projects.id) projects.*, project_revisions.title AS rev_title')
                         .order('projects.id, rev_title')
      @projects = @projects.sort_by(&:rev_title).reverse
    when 'preparation_lowest'
      @projects = @projects.joins(pages: :published_revision)
                           .where(pages: { page_type: 'preparation' })
                           .select('projects.*, revisions.total_score')
                           .order('revisions.total_score').distinct
    when 'preparation_highest'
      @projects = @projects.joins(pages: :published_revision)
                           .where(pages: { page_type: 'preparation' })
                           .select('projects.*, revisions.total_score')
                           .order('revisions.total_score DESC').distinct
    when 'product_lowest'
      @projects = @projects.joins(pages: :published_revision)
                           .where(pages: { page_type: 'product' })
                           .select('projects.*, revisions.total_score')
                           .order('revisions.total_score').distinct
    when 'product_highest'
          @projects = @projects.joins(pages: :published_revision)
                               .where(pages: { page_type: 'product' })
                               .select('projects.*, revisions.total_score')
                               .order('revisions.total_score DESC').distinct
    else
      @projects = @projects.order(updated_at: :desc)
    end
  end
end
