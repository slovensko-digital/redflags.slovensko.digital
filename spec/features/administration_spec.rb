require 'rails_helper'

RSpec.feature 'Administration', type: :feature do
  scenario 'As admin I want to synchronize all pages from discourse' do
    log_in_as_admin
    visit admin_root_path

    expect do
      click_button 'Synchronize'
    end.to have_enqueued_job(SyncCategoryTopicsJob)
  end


  def log_in_as_admin
    page.driver.browser.authorize('admin', 'admin')
  end
end
