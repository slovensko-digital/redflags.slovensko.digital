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
    create(:page, :unpublished)

    authorize_as_admin
    visit admin_root_path

    within 'table' do
      expect(page).to have_content('published')
      expect(page).to have_content('unpublished')
    end
  end

  scenario 'As admin I want to publish page' do
    create(:page, :unpublished)

    authorize_as_admin
    visit admin_root_path

    click_on 'Publish'

    within 'table' do
      expect(page).to have_content('published')
    end
  end

  scenario 'As admin I want to unpublish page' do
    create(:page, :published)

    authorize_as_admin
    visit admin_root_path

    click_on 'Unpublish'

    within 'table' do
      expect(page).to have_content('unpublished')
    end
  end

  scenario 'As admin I want to see all revisions of page' do
    create(:page, :published)
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

  scenario 'As admin I want to publish non-latest page revision' do
    create(:page, :unpublished)
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

  private

  def authorize_as_admin
    page.driver.browser.authorize('admin', 'admin')
  end
end
