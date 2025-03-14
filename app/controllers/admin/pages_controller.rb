class Admin::PagesController < AdminController
  before_action :load_page, only: [:show, :preview, :publish, :unpublish, :sync_one]

  def index
    @pages = Page.includes(phase: :project).order(created_at: :desc)
    @projects = @pages.map { |page| page.phase&.project }.uniq
    
    @job_stats = QueJob.job_stats
  end

  def show
    @revisions = @page.revisions.order(version: :desc).page(params[:page])
    @project = @page.phase ? @page.phase.project : Project.find_by(id: @page.id)
  end

  def preview
    @phase = @page.phase
    if @phase.present?
      if params['version'] == 'latest'
        @phase_revision = @phase.revisions.find_by(revision: @page.latest_revision)
      else
        @phase_revision = @phase.revisions.find_by(revision: @page.revisions.find_by(version: params['version']))
      end
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
      @project = @phase.project
      
    else
      if params['version'] == 'latest'
        @phase_revision = @page.latest_revision
      else
        @phase_revision = @page.revisions.find_by(version: params['version'])
      end
    end
  end

  def publish
    if params['version'] == 'latest'
      revision = @page.latest_revision
      @page.update!(published_revision: revision)
    else
      revision = @page.revisions.find_by!(version: params['version'])
      @page.update!(published_revision: revision)
    end

    @page.publish_and_enqueue_jobs(revision)

    redirect_back fallback_location: { action: :index }
  end

  def unpublish
    revision_id = @page.published_revision.id if @page.published_revision.present?

    @page.update!(published_revision: nil)
    @page.unpublish_and_enqueue_jobs(revision_id)

    redirect_back fallback_location: { action: :index }
  end

  def sync
    SyncAllTopicsJob.perform_later

    redirect_back fallback_location: { action: :index }
  end

  def sync_google
    SyncAllTopicsJob.perform_later(sync_all: false)

    redirect_back fallback_location: { action: :index }
  end

  def sync_one
    if @page.phase.present?
      SyncOneTopicJob.perform_later(@page.id)
    else
      SyncTopicJob.perform_later(nil, @page.id)
    end

    redirect_back fallback_location: { action: :index }
  end

  private

  def load_page
    @page = Page.find(params[:id])
  end
end
