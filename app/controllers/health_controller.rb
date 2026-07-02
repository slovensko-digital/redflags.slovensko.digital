class HealthController < ApplicationController
  def index
    render plain: 'OK'
  end
end
