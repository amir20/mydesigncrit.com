DesigncritIo::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :projects, except: [:edit, :new] do
    resources :pages, except: [:edit, :new, :update] do
      resources :crits, except: [:edit, :new]
    end
  end

  resources :users, only: [:show] do
    resources :projects, only: [:destroy, :index]
    resources :crits, only: [:index]
  end

  get '/v/:id', to: 'projects#share', as: :share
  post '/v/:id', to: 'projects#email', as: :email

  root 'welcome#index'
  match '/delayed_job' => DelayedJobWeb, anchor: false, via: [:get, :post]

  %w( 404 422 500 ).each do |code|
    get code, to: 'errors#show', code: code
  end
end
