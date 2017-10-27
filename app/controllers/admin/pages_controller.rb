class Admin::PagesController < AdminController
  before_action :load_page, only: [:show, :switch, :publish, :unpublish]

  def index
    @pages = Page.order(id: :desc).page(params[:page])
  end

  def show
    @revisions = @page.revisions.order(version: :desc).page(params[:page])
  end

  def switch
    @page.update!(latest_revision: @page.revisions.find_by!(version: params['version']))

    redirect_to action: :show
  end

  def publish
    @page.update!(published_revision: @page.latest_revision)

    redirect_to action: :index
  end

  def unpublish
    @page.update!(published_revision: nil)

    redirect_to action: :index
  end

  def sync
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))

    redirect_to action: :index
  end

  private

  def load_page
    @page = Page.find(params[:id])
  end
end
