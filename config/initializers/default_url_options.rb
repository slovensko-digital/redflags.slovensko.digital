Rails.application.routes.default_url_options[:host] = Rails.application.config_for(:app).dig(:host) || 'localhost:3000'
