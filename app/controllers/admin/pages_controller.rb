class Admin::PagesController < AdminController
  before_action :load_page, only: [:show, :switch, :publish, :unpublish]

  def index
    @pages = Page.order(id: :desc).page(params[:page])
  end

  def show
    @revisions = @page.revisions.order(version: :desc).page(params[:page])
  end

  def publish
    @page.update!(published_revision: @page.revisions.find_by!(version: params['version']))

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
