require 'rails_helper'

RSpec.describe 'Que web', type: :request do
  it 'shows the queue on the host of the app' do
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(ENV.fetch('ADMIN_USER'), ENV.fetch('ADMIN_PASSWORD'))

    get '/admin/que', headers: { 'HTTP_AUTHORIZATION' => credentials, 'HTTP_HOST' => 'redflags.slovensko.digital' }

    expect(response).to have_http_status(:ok)
  end
end
