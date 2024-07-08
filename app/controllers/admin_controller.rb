class AdminController < ApplicationController
  before_action :authenticate_with_api_token!, only: [:sync, :sync_google, :sync_one]

  http_basic_authenticate_with name: ENV['ADMIN_USER'], password: ENV['ADMIN_PASSWORD']

  layout 'admin'

  private

  def authenticate_with_api_token!
    if request.headers['X-API-Token'].present?
      token = request.headers['X-API-Token']
      render json: { error: 'Unauthorized' }, status: :unauthorized unless token && token == ENV['ADMIN_API_TOKEN']
    end
  end
end
