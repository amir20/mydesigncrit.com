DesigncritIo::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :projects, except: [:edit, :new] do
    resources :pages, except: [:edit, :new] do
      resources :crits, except: [:edit, :new]
    end
  end

  get '/v/:id', to: 'projects#share', as: :share

  root 'welcome#index'
  get '/delayed_job' => DelayedJobWeb, :anchor => false

end
