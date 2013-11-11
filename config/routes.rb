DesigncritIo::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resource :welcome

  resource :projects do
    resource :pages
  end

  root 'welcome#index'
  get '/delayed_job' => DelayedJobWeb, :anchor => false
end
