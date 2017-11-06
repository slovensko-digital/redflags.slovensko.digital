class Admin::PagesController < AdminController
  before_action :load_page, only: [:show, :preview, :publish, :unpublish]

  def index
    @pages = Page.order(id: :desc).page(params[:page])
  end

  def show
    @revisions = @page.revisions.order(version: :desc).page(params[:page])
  end

  def preview
    if params['version'] == 'latest'
      @project = ProjectRevision.find_by!(revision: @page.latest_revision)
    else
      @project = ProjectRevision.joins(:project, :revision).find_by!(projects: { page: @page }, revisions: { version: params['version'] })
    end

    @rating_types_by_phase = RatingType.all.group_by(&:rating_phase)
    @ratings_by_type = @project.ratings.index_by(&:rating_type)
  end

  def publish
    if params['version'] == 'latest'
      @page.update!(published_revision: @page.latest_revision)
    else
      @page.update!(published_revision: @page.revisions.find_by!(version: params['version']))
    end

    redirect_back fallback_location: { action: :index }
  end

  def unpublish
    @page.update!(published_revision: nil)

    redirect_back fallback_location: { action: :index }
  end

  def sync
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))

    redirect_back fallback_location: { action: :index }
  end

  private

  def load_page
    @page = Page.find(params[:id])
  end
end
