class ProjectsController < ApplicationController
  def show
    @project = Project.find_by!(id: params[:project_id])
    phase_type_map = { 'hodnotenie-pripravy' => 'Prípravná fáza', 'hodnotenie-produktu' => 'Fáza produkt' }
    phase_name = phase_type_map[params[:revision_type]] || params[:revision_type]

    @once_published_phase_revisions = PhaseRevision.once_published
                                                   .joins(phase: :project)
                                                   .where(projects: { id: @project.id })
                                                   .where(phases: { phase_type: PhaseType.find_by(name: phase_name) })
                                                   .joins(:revision)
                                                   .joins(revision: :page)
                                                   .order('phase_revisions.published_at DESC')

    @phase_revision = PhaseRevision.joins(phase: { project: :phases })
                                   .where(projects: { id: @project.id })
                                   .where(phases: { phase_type: PhaseType.find_by(name: phase_name) })
                                   .where(published: true)
                                   .first
    if @phase_revision
      @revision = @phase_revision.revision
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'
    end
  end

  def pdf
    @project = Project.find_by!(id: params[:project_id])
    phase_type_map = { 'hodnotenie-pripravy' => 'Prípravná fáza', 'hodnotenie-produktu' => 'Fáza produkt' }
    phase_name = phase_type_map[params[:revision_type]] || params[:revision_type]

    @phase_revision = PhaseRevision.joins(phase: { project: :phases })
                                   .where(projects: { id: @project.id })
                                   .where(phases: { phase_type: PhaseType.find_by(name: phase_name) })
                                   .where(published: true)
                                   .first
    if @phase_revision
      @revision = @phase_revision.revision
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
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
    @project = Project.find_by!(id: params[:project_id])
    phase_type_map = { 'hodnotenie-pripravy' => 'Prípravná fáza', 'hodnotenie-produktu' => 'Fáza produkt' }
    phase_name = phase_type_map[params[:revision_type]] || params[:revision_type]

    @phase_revision = PhaseRevision.joins(phase: { project: :phases })
                                   .joins(:revision)
                                   .where(projects: { id: @project.id })
                                   .where(phases: { phase_type: PhaseType.find_by(name: phase_name).id })
                                   .where(revisions: { version: params[:version] })
                                   .first

    if @phase_revision
      @revision = @phase_revision.revision
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'

      render :show
    end
  end

  def index
    @selected_tag = params[:tag]
    @projects = Project.joins(phases: :published_revision).distinct

    if ProjectsHelper::ALLOWED_TAGS.keys.include?(@selected_tag)
      @projects = @projects.joins(phases: :published_revision)
                           .where(phase_revisions: { tags: @selected_tag })
    end

    case params[:sort]
    when 'newest'
      @projects = Project.joins(phases: :published_revision)
                         .select('projects.*, MAX(phase_revisions.published_at) AS newest_published_at')
                         .group('projects.id')
                         .order('newest_published_at DESC')
    when 'oldest'
      @projects = Project.joins(phases: :published_revision)
                         .select('projects.*, MIN(phase_revisions.published_at) AS oldest_published_at')
                         .group('projects.id')
                         .order('oldest_published_at')
    when 'alpha'
      @projects = Project.joins(phases: :published_revision)
                         .select('DISTINCT ON (projects.id) projects.*, phase_revisions.title AS alpha_title')
                         .order('projects.id, alpha_title')
                         .sort_by(&:alpha_title)
    when 'alpha_reverse'
      @projects = Project.joins(phases: :published_revision)
                         .select('DISTINCT ON (projects.id) projects.*, phase_revisions.title AS alpha_title')
                         .order('projects.id, alpha_title')
                         .sort_by(&:alpha_title).reverse
    when 'preparation_lowest'
      @projects = Project.joins(phases: :published_revision)
                         .where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') })
                         .select('projects.*, phase_revisions.total_score')
                         .order('phase_revisions.total_score ASC NULLS LAST')
                         .distinct
    when 'preparation_highest'
      @projects = Project.joins(phases: :published_revision)
                         .where(phases: { phase_type: PhaseType.find_by(name: 'Prípravná fáza') })
                         .select('projects.*, phase_revisions.total_score')
                         .order('phase_revisions.total_score DESC NULLS LAST')
                         .distinct
    when 'product_lowest'
      @projects = Project.joins(phases: :published_revision)
                         .where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') })
                         .select('projects.*, phase_revisions.total_score')
                         .order('phase_revisions.total_score ASC NULLS LAST')
                         .distinct
    when 'product_highest'
      @projects = Project.joins(phases: :published_revision)
                         .where(phases: { phase_type: PhaseType.find_by(name: 'Fáza produkt') })
                         .select('projects.*, phase_revisions.total_score')
                         .order('phase_revisions.total_score DESC NULLS LAST')
                         .distinct
    else
      @projects = @projects.order(updated_at: :desc)
    end
  end
end
