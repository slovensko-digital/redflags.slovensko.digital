require 'rails_helper'

RSpec.feature 'Administration', type: :feature do
  include ActionView::RecordIdentifier

  scenario 'As admin I want to synchronize all pages' do
    authorize_as_admin
    visit admin_root_path

    expect { click_on 'Synchronize' }.to have_enqueued_job(SyncAllTopicsJob)
  end

  def see_all_pages
    authorize_as_admin
    visit admin_root_path

    within 'table' do
      expect(page).to have_content('published')
      expect(page).to have_content('unpublished')
    end
  end

  scenario 'As admin I want to see all pages' do
    create(:page, :published)
    create(:page, :unpublished)
    see_all_pages
  end

  scenario 'As admin I want to see all project pages' do
    page1 = create(:page, :published)
    page2 = create(:page, :unpublished)
    create(:project, pages: [page1])
    create(:project, pages: [page2])
    see_all_pages
  end

  def preview_page
    authorize_as_admin
    visit admin_root_path

    click_on 'Preview'

    expect(page).to have_content("Preview of page Red Flags: IS Obchodného registra at latest version #{Page.first.revisions.first.version}")
  end

  scenario 'As admin I want to preview page' do
    page_to_preview = create(:page)
    create(:project, pages: [page_to_preview])
    revision = page_to_preview.revisions.first

    SyncRevisionJob.perform_now(revision)

    preview_page
  end

  def publish_page
    authorize_as_admin
    visit admin_root_path

    click_on 'Publish'

    within 'table' do
      expect(page).to have_content('published')
    end
  end

  scenario 'As admin I want to publish page' do
    allow(UpdateMultipleSheetColumnsJob).to receive(:perform_later)
    allow(ExportTopicIntoSheetJob).to receive(:perform_later)

    page_to_preview = create(:page, :unpublished)
    project = create(:project, pages: [page_to_preview])
    revision = page_to_preview.revisions.first

    project_revision = project.revisions.find_or_initialize_by(revision_id: revision&.id)
    project_revision.load_from_data(revision&.raw)
    project_revision.save!

    publish_page
  end

  def unpublish_page
    authorize_as_admin
    visit admin_root_path

    click_on 'Unpublish'

    within 'table' do
      expect(page).to have_content('unpublished')
    end
  end

  scenario 'As admin I want to unpublish page' do
    allow(UpdateMultipleSheetColumnsJob).to receive(:perform_later)

    page_to_preview = create(:page, :published)
    project = create(:project, pages: [page_to_preview])
    revision = page_to_preview.revisions.first

    project_revision = project.revisions.find_or_initialize_by(revision_id: revision&.id)
    project_revision.load_from_data(revision&.raw)
    project_revision.save!
    unpublish_page
  end

  def see_all_revisions
    authorize_as_admin
    visit admin_root_path

    click_on Page.first.id

    within :id, dom_id(Revision.first) do
      expect(page).to have_content('published')
    end

    within :id, dom_id(Revision.second) do
      expect(page).to have_content('latest')
    end
  end

  scenario 'As admin I want to see all revisions of page' do
    create(:page, :published)
    create(:revision, page: Page.first)
    see_all_revisions
  end

  scenario 'As admin I want to see all revisions of project page' do
    page = create(:page, :published)
    create(:project, pages: [page])
    create(:revision, page: page)

    see_all_revisions
  end

  def preview_non_latest_revision(version)
    authorize_as_admin
    visit admin_root_path
    click_on Page.first.id
    within :id, dom_id(Revision.find_by_version(version)) do
      expect(page).not_to have_content('published')
      expect(page).not_to have_content('latest')
    end
  end

  scenario 'As admin I want to preview non-latest page revision' do
    page = create(:page, :unpublished)
    project = create(:project, pages: [page])

    older_revision = create(:revision, page: page, version: 1)
    create_project_revision(project, older_revision)

    latest_revision = create(:revision, page: page, version: 2)
    create_project_revision(project, latest_revision)

    preview_non_latest_revision(older_revision.version)
  end

  def create_project_revision(project, revision)
    project_revision = project.revisions.find_or_initialize_by(revision_id: revision&.id)
    project_revision.load_from_data(revision&.raw)
    project_revision.save!
  end

  def publish_non_latest_revision(version)
    authorize_as_admin
    visit admin_root_path
    click_on Page.first.id

    within :id, dom_id(Revision.find_by_version(version)) do
      expect(page).not_to have_content('published')
      expect(page).not_to have_content('latest')
      click_on 'Publish'
    end

    within :id, dom_id(Revision.find_by_version(version)) do
      expect(page).to have_content('published')
    end
  end

  scenario 'As admin I want to publish non-latest page revision' do
    page = create(:page, :unpublished)
    project = create(:project, pages: [page])
    # create two revisions for project page
    older_revision = create(:revision, page: page, version: 1)
    create(:project_revision, revision: older_revision, project: project)

    latest_revision = create(:revision, page: page, version: 2)
    create(:project_revision, revision: latest_revision, project: project)
    # publish older, non-latest project page revision
    publish_non_latest_revision(1)
  end

  private

  def authorize_as_admin
    page.driver.browser.authorize('admin', 'admin')
  end
end
