class Admin::PagesController < AdminController
  def index
    @pages = Page.order(id: :desc).page(params[:page])
  end

  def sync
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))

    redirect_to action: :index
  end
end
