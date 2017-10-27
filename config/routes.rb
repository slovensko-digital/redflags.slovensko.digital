require 'que/web'

Que::Web.use(Rack::Auth::Basic) do |username, password|
  username == ENV.fetch('ADMIN_USER') && password == ENV.fetch('ADMIN_PASSWORD')
end

Rails.application.routes.draw do
  namespace :admin do
    root to: 'pages#index'

    resources :pages do
      patch :publish, on: :member
      patch :unpublish, on: :member

      put :sync, on: :collection
    end

    mount Que::Web, at: 'que'
  end

  root to: 'static#kitchen_sink'
end
