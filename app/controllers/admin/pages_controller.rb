class Admin::PagesController < AdminController
  def index
  end

  def sync
    SyncCategoryTopicsJob.perform_later(ENV.fetch('REDFLAGS_CATEGORY_SLUG'))

    redirect_to action: :index
  end
end
