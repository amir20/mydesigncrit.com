DesigncritIo::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  resource :welcome, only: :index

  resources :projects do
    resources :pages do
      resources :crits
    end
  end

  root 'welcome#index'
  get '/delayed_job' => DelayedJobWeb, :anchor => false
end
