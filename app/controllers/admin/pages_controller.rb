class Admin::PagesController < AdminController
  def index
    @pages = Page.order(id: :desc).page(params[:page])
  end

  def publish
    @page = Page.find(params[:id])

    @page.update!(published_revision: @page.latest_revision)

    redirect_to action: :index
  end

  def unpublish
    @page = Page.find(params[:id])

    @page.update!(published_revision: nil)

    redirect_to action: :index
  end

  def sync
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))

    redirect_to action: :index
  end
end
