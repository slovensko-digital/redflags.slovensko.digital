Rails.application.routes.draw do
  namespace :admin do
    root to: 'pages#index'

    resources :pages do
      put :sync, on: :collection
    end
  end

  root to: 'static#kitchen_sink'
end
