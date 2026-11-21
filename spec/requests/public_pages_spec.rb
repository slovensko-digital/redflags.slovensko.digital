require 'rails_helper'

RSpec.describe 'Public pages', type: :request do
  let(:phase_type) { create(:phase_type, name: 'Prípravná fáza') }
  let(:project) { create(:project) }
  let!(:page) { create(:page, :published, phase: create(:phase, project: project, phase_type: phase_type)) }

  before do
    page.published_revision.phase_revision.update!(phase: page.phase, published: true)
  end

  it 'shows the home page with the best and the worst rated projects' do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('Red Flags: IS Obchodného registra - Prípravná fáza')
  end

  [nil, 'newest', 'oldest', 'alpha', 'alpha_reverse', 'preparation_lowest', 'preparation_highest'].each do |sort|
    it "lists the projects sorted by #{sort || 'rating'}" do
      get projects_path(sort: sort)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(project_show_revision_type_path(project, 'hodnotenie-pripravy'))
    end
  end

  %w[product_lowest product_highest].each do |sort|
    it "lists only the projects rated in the product phase sorted by #{sort}" do
      get projects_path(sort: sort)

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include(project_show_revision_type_path(project, 'hodnotenie-pripravy'))
    end
  end

  it 'lists more projects with the same number of queries' do
    count_queries = lambda do
      queries = 0
      counter = ->(*, payload) { queries += 1 unless payload[:name] == 'SCHEMA' || payload[:cached] }
      ActiveSupport::Notifications.subscribed(counter, 'sql.active_record') { get projects_path }
      queries
    end
    count_queries.call
    queries_for_one_project = count_queries.call

    2.times do
      other_page = create(:page, :published, phase: create(:phase, phase_type: phase_type))
      other_page.published_revision.phase_revision.update!(phase: other_page.phase, published: true)
    end

    expect(count_queries.call).to eq(queries_for_one_project)
  end

  it 'shows the rating of the project' do
    get project_show_revision_type_path(project, 'hodnotenie-pripravy')

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('IS Obchodného registra')
  end

  it 'shows the rating of the project for printing' do
    get project_show_pdf_project_path(project, 'hodnotenie-pripravy')

    expect(response).to have_http_status(:ok)
  end

  it 'shows a page about the project' do
    about = create(:page, :published)
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('REDFLAGS_ABOUT_PAGE_ID').and_return(about.id.to_s)

    get about_path

    expect(response).to have_http_status(:ok)
  end
end
