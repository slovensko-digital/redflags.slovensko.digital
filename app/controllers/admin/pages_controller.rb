class Admin::PagesController < AdminController
  before_action :load_page, only: [:show, :preview, :publish, :unpublish, :sync_one]

  def index
    @pages = Page.includes(:project).order(id: :desc)
    @projects = @pages.map(&:project)
  end

  def show
    @revisions = @page.revisions.order(version: :desc).page(params[:page])
    @project = @page.project
  end

  def preview
    @project = @page.project

    if @project.present?
      if params['version'] == 'latest'
        @project_revision = @project.revisions.find_by!(revision: @page.latest_revision)
      else
        @project_revision = @project.revisions.find_by!(revision: Revision.where(page_id: @page.id, version: params['version']))
      end

      @ratings_by_type = @project_revision.revision.ratings.index_by(&:rating_type)
    else
      if params['version'] == 'latest'
        @project_revision = @page.latest_revision
      else
        @project_revision = @page.revisions.find_by!(version: params['version'])
      end
    end
  end

  def publish
    if params['version'] == 'latest'
      revision_id = @page.latest_revision.id
      @page.update!(published_revision: @page.latest_revision)
    else
      revision_id = @page.revisions.find_by!(version: params['version']).id
      @page.update!(published_revision: @page.revisions.find_by!(version: params['version']))
    end

    related_revisions = ProjectRevision.where(revision_id: @page.revisions.ids).where.not(revision_id: revision_id)
    related_revisions.update_all(published: false) if revision_id

    new_revision = ProjectRevision.find_by(revision_id: revision_id)
    new_revision.update!(published: true, was_published: true, published_at: Time.now) if new_revision

    updates = [
      {
        column_names: {"preparation" => "Príprava publikovaná?", "product" => "Produkt publikovaný?"},
        page_type: @page.page_type,
        published_value: "Áno"
      },
      {
        column_names: {"preparation" => "Dátum publikácie prípravy", "product" => "Dátum publikácie produktu"},
        page_type: @page.page_type,
        published_value: new_revision.published_at.in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')
      },
      {
        column_names: {"project" => "Dátum poslednej aktualizácie"},
        page_type: "project",
        published_value: new_revision.published_at.in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')
      },
      {
        column_names: {"preparation" => "RF web príprava", "product" => "RF web produkt"},
        page_type: @page.page_type,
        published_value: %(=HYPERLINK("https://redflags.slovensko.digital/admin/pages/#{@page.id}"; "Admin link"))
      }
    ]
    UpdateMultipleSheetColumnsJob.perform_later(@page.id, updates)
    ExportTopicIntoSheetJob.perform_later(new_revision)

    redirect_back fallback_location: { action: :index }
  end

  def unpublish
    revision_id = @page.published_revision.id if @page.published_revision.present?

    @page.update!(published_revision: nil)

    ProjectRevision.where(revision_id: revision_id).update_all(published: false, published_at: nil) if revision_id

    updates = [
      {
        column_names: {"preparation" => "Príprava publikovaná?", "product" => "Produkt publikovaný?"},
        page_type: @page.page_type,
        published_value: "Nie"
      },
      {
        column_names: {"preparation" => "Dátum publikácie prípravy", "product" => "Dátum publikácie produktu"},
        page_type: @page.page_type,
        published_value: ""
      },
      {
        column_names: {"preparation" => "RF web príprava", "product" => "RF web produkt"},
        page_type: @page.page_type,
        published_value: ""
      }
    ]
    UpdateMultipleSheetColumnsJob.perform_later(@page.id, updates)

    redirect_back fallback_location: { action: :index }
  end

  def sync
    SyncAllTopicsJob.perform_later

    redirect_back fallback_location: { action: :index }
  end

  def sync_one
    SyncOneTopicJob.perform_later(@page.id)

    redirect_back fallback_location: { action: :index }
  end

  private

  def load_page
    @page = Page.find(params[:id])
  end
end
