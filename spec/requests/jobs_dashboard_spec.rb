require 'rails_helper'

RSpec.describe 'Jobs dashboard', type: :request do
  let(:host) { { 'HTTP_HOST' => 'redflags.slovensko.digital' } }

  it 'shows the jobs to the admins' do
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch('ADMIN_USER'), ENV.fetch('ADMIN_PASSWORD'))

    get '/admin/jobs/jobs', headers: host.merge('HTTP_AUTHORIZATION' => credentials)

    expect(response).to have_http_status(:ok)
  end

  it 'asks for the login' do
    get '/admin/jobs/jobs', headers: host

    expect(response).to have_http_status(:unauthorized)
  end
end
