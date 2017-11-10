require 'rails_helper'

RSpec.feature 'Administration', type: :feature do
  include ActionView::RecordIdentifier

  scenario 'As admin I want to synchronize all pages' do
    authorize_as_admin
    visit admin_root_path

    expect { click_on 'Synchronize' }.to have_enqueued_job(SyncCategoryTopicsJob)
  end

  scenario 'As admin I want to see all pages' do
    create(:page, :published)
    create(:project, page: Page.first)

    create(:page, :unpublished)
    create(:project, page: Page.second)

    authorize_as_admin
    visit admin_root_path

    within 'table' do
      expect(page).to have_content('published')
      expect(page).to have_content('unpublished')
    end
  end

  scenario 'As admin I want to preview project page' do
    project = create(:project)

    authorize_as_admin
    visit admin_root_path

    click_on 'Preview'

    expect(page).to have_content("Preview of page Red Flags: IS Obchodného registra at latest version #{project.revisions.first.version}")
  end

  scenario 'As admin I want to publish project page' do
    create(:page, :unpublished)
    create(:project, page: Page.first)

    authorize_as_admin
    visit admin_root_path

    click_on 'Publish'

    within 'table' do
      expect(page).to have_content('published')
    end
  end

  scenario 'As admin I want to unpublish project page' do
    create(:page, :published)
    create(:project, page: Page.first)

    authorize_as_admin
    visit admin_root_path

    click_on 'Unpublish'

    within 'table' do
      expect(page).to have_content('unpublished')
    end
  end

  scenario 'As admin I want to see all revisions of page' do
    create(:page, :published)
    create(:project, page: Page.first)
    create(:revision, page: Page.first)

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

  scenario 'As admin I want to publish non-latest project page revision' do
    create(:page, :unpublished)
    create(:project, page: Page.first)
    create(:revision, page: Page.first)

    authorize_as_admin
    visit admin_root_path

    click_on Page.first.id

    within :id, dom_id(Revision.first) do
      expect(page).not_to have_content('published')
      expect(page).not_to have_content('latest')

      click_on 'Publish'
    end

    within :id, dom_id(Revision.first) do
      expect(page).to have_content('published')
    end
  end

  scenario 'As admin I want to edit project category' do
    create(:project)

    authorize_as_admin
    visit admin_root_path

    click_on Page.first.id

    within 'h4' do
      expect(page).to have_content('boring')
    end

    choose 'good'
    click_on 'Update'

    within 'h4' do
      expect(page).to have_content('good')
    end
  end

  private

  def authorize_as_admin
    page.driver.browser.authorize('admin', 'admin')
  end
end
