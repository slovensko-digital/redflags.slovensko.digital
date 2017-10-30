require 'que/web'

Que::Web.use(Rack::Auth::Basic) do |username, password|
  username == ENV.fetch('ADMIN_USER') && password == ENV.fetch('ADMIN_PASSWORD')
end

Rails.application.routes.draw do
  resources :projects, path: 'projekty'

  namespace :admin do
    root to: 'pages#index'

    resources :pages do
      put :sync, on: :collection
    end
    
    mount Que::Web, at: 'que'
  end

  get '/kitchen-sink', to: 'static#kitchen_sink'

  root to: 'static#index'
end
