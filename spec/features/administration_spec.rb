require 'rails_helper'

RSpec.feature 'Administration', type: :feature do
  scenario 'As admin I want to synchronize all pages from discourse' do
    log_in_as_admin
    visit admin_root_path

    expect do
      click_button 'Synchronize'
    end.to have_enqueued_job(SyncCategoryTopicsJob)
  end

  scenario 'As admin I want to see some pages' do
    create(:page, :published)
    create(:page, :unpublished)

    log_in_as_admin
    visit admin_root_path

    within 'table' do
      expect(page).to have_content('published')
      expect(page).to have_content('unpublished')
    end
  end

  def log_in_as_admin
    page.driver.browser.authorize('admin', 'admin')
  end
end
