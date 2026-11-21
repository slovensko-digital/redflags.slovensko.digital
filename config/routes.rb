Rails.application.routes.draw do
  # Ratings imported from Google Docs keep the path of the star images with the digest of the build that
  # imported them. A build with another digest does not have that file, so send it to the current one.
  get 'assets/emoji/:name-:digest.png',
      to: redirect(status: 302) { |params, _request| ActionController::Base.helpers.image_path("emoji/#{params[:name]}.png") },
      constraints: { name: /star|grey_star/, digest: /\h+/ }

  get 'projekty/:id', to: redirect('/hodnotenia/%{id}/hodnotenie-pripravy')
  get 'projekty/:id/hodnotenie-pripravy', to: redirect('/hodnotenia/%{id}/hodnotenie-pripravy')

  resources :projects, path: 'hodnotenia' do
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

    namespace :metais do
      resources :projects do
        post :create_human_origin, on: :member
        post :run_ai_extraction, on: :member

        resources :project_origins, only: [:edit, :update, :create] do
          delete 'remove_event/:event_id', to: 'project_origins#remove_event', as: 'remove_event'
          delete 'remove_supplier/:supplier_id', to: 'project_origins#remove_supplier', as: 'remove_supplier'
          delete 'remove_link/:link_id', to: 'project_origins#remove_link', as: 'remove_link'
          delete 'remove_document/:document_id', to: 'project_origins#remove_document', as: 'remove_document'

          post 'add_event', to: 'project_origins#add_event', as: 'add_event'
          post 'add_supplier', to: 'project_origins#add_supplier', as: 'add_supplier'
          post 'add_link', to: 'project_origins#add_link', as: 'add_link'
          post 'add_document', to: 'project_origins#add_document', as: 'add_document'
          patch 'update_group_order', to: 'project_origins#update_group_order', as: 'update_group_order'
        end
      end
    end

    resources :projects

    mount GoodJob::Engine, at: 'jobs', as: :jobs
  end

  namespace :metais, path: '' do
    resources :projects, path: 'statne-it-projekty', only: [:index, :show]
  end

  post 'newsletter/subscribe', to: 'newsletter_subscriptions#subscribe', as: :newsletter_subscribe
  get 'newsletter/confirmed', to: 'newsletter_subscriptions#confirmed', as: :newsletter_confirmed

  get 'o-projekte', as: 'about', to: 'static#about'
  get 'ako-hodnotime', as: 'about_rating', to: 'static#about_rating'
  get 'ako-sa-zapojit', as: 'contribute', to: 'static#contribute'
  get 'casto-kladene-otazky', as: 'faq', to: 'static#faq'
  get 'statne-it-v-cislach', as: 'stats', to: 'static#stats'

  root to: 'static#index'

  get :health, to: 'health#show'
end
