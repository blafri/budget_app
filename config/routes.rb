Rails.application.routes.draw do
  root 'static_pages#welcome_page'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :bank_accounts, only: [:show, :update]
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :bank_accounts, except: [:index, :edit, :update]
end
