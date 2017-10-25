class Admin::PagesController < AdminController
  def index
    @pages = Page.order(id: :desc).page(params[:page]).per(100)
  end

  def sync
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))

    redirect_to action: :index
  end
end
