class HealthController < ApplicationController
  def show
    ActiveRecord::Base.connection.verify!

    if ActiveRecord::Base.connection.active?
      render status: :ok, json: { ok: true }
    else
      render status: :service_unavailable, json: { ok: false }
    end
  end
end
