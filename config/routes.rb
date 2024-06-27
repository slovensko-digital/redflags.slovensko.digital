require 'que/web'

Que::Web.use(Rack::Auth::Basic) do |username, password|
  username == ENV.fetch('ADMIN_USER') && password == ENV.fetch('ADMIN_PASSWORD')
end

Rails.application.routes.draw do
  resources :projects, path: 'projekty' do
    get ':revision_type/verzia/:version', to: 'phase_revision#show_history', as: 'show_history'
    get ':revision_type', to: 'phase_revision#show', as: 'show_revision_type'
    get ':revision_type/pdf', to: 'phase_revision#pdf', as: 'show_pdf_project'
  end

  namespace :admin do
    root to: 'pages#index'

    resources :pages do
      get :preview, on: :member

      patch :publish, on: :member
      patch :unpublish, on: :member

      put :sync_google, on: :collection
      put :sync, on: :collection
      put :sync_one, on: :member
    end

    resources :projects

    mount Que::Web, at: 'que'
  end

  get 'o-projekte', as: 'about', to: 'static#about'
  get 'ako-hodnotime', as: 'about_rating', to: 'static#about_rating'
  get 'ako-sa-zapojit', as: 'contribute', to: 'static#contribute'
  get 'casto-kladene-otazky', as: 'faq', to: 'static#faq'
  get 'statne-it-v-cislach', as: 'stats', to: 'static#stats'

  root to: 'static#index'
end
