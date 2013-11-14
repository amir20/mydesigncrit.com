DesigncritIo::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resource :welcome, only: :index

  resources :projects do
    resources :pages
  end

  root 'welcome#index'
  get '/delayed_job' => DelayedJobWeb, :anchor => false
end
