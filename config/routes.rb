Rails.application.routes.draw do
  authenticated :user do
    root to: 'dashboards#index', as: 'authenticated_root'
  end

  root 'static_pages#welcome_page'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :bank_accounts, except: [:index]
end
