class Admin::PagesController < AdminController
  before_action :load_page, only: [:show, :preview, :publish, :unpublish, :sync_one]

  def index
    @pages = Page.includes(phase: :project).order(id: :desc)
    @projects = @pages.map { |page| page.phase.project }.uniq
  end

  def show
    @revisions = @page.revisions.order(version: :desc).page(params[:page])
    @project = @page.phase.project
  end

  def preview
    @phase = @page.phase

    if @project.present?
      if params['version'] == 'latest'
        @phase_revision = @phase.revisions.find_by!(revision: @page.latest_revision)
      else
        @phase_revision = @phase.revisions.find_by!(revision: @page.revisions.where(version: params['version']))
      end

      @ratings_by_type = @phase.revisions.ratings.index_by(&:rating_type)
    else
      if params['version'] == 'latest'
        @phase_revision = PhaseRevision.find_by(revision: @page.latest_revision)
      else
        @phase_revision = PhaseRevision.joins(:revision)
                                       .find_by(revisions: { version: params['version'] })
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

    related_revisions = PhaseRevision.where(revision_id: @page.revisions.ids).where.not(revision_id: revision_id)
    related_revisions.update_all(published: false) if revision_id

    new_revision = PhaseRevision.find_by(revision_id: revision_id)
    new_revision.update!(published: true, was_published: true, published_at: Time.now) if new_revision

    updates = [
      {
        column_names: {"Prípravná fáza" => "Príprava publikovaná?", "Fáza produkt" => "Produkt publikovaný?"},
        page_type: @page.phase.phase_type.name,
        published_value: "Áno"
      },
      {
        column_names: {"Prípravná fáza" => "Dátum publikácie prípravy", "Fáza produkt" => "Dátum publikácie produktu"},
        page_type: @page.phase.phase_type.name,
        published_value: new_revision.published_at.in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')
      },
      {
        column_names: {"project" => "Dátum poslednej aktualizácie"},
        page_type: "project",
        published_value: new_revision.published_at.in_time_zone('Europe/Bratislava').strftime('%H:%M %d.%m.%Y')
      },
      {
        column_names: {"Prípravná fáza" => "RF web príprava", "Fáza produkt" => "RF web produkt"},
        page_type: @page.phase.phase_type.name,
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

    PhaseRevision.where(revision_id: revision_id).update_all(published: false, published_at: nil) if revision_id

    updates = [
      {
        column_names: {"Prípravná fáza" => "Príprava publikovaná?", "Fáza produkt" => "Produkt publikovaný?"},
        page_type: @page.phase.phase_type.name,
        published_value: "Nie"
      },
      {
        column_names: {"Prípravná fáza" => "Dátum publikácie prípravy", "Fáza produkt" => "Dátum publikácie produktu"},
        page_type: @page.phase.phase_type.name,
        published_value: ""
      },
      {
        column_names: {"Prípravná fáza" => "RF web príprava", "Fáza produkt" => "RF web produkt"},
        page_type: @page.phase.phase_type.name,
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
