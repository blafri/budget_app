Rails.application.routes.draw do
  # Set home page for authenticated users
  authenticated :user do
    root to: 'dashboards#index', as: 'authenticated_root'
  end

  # Home page for everybody unauthenticated users
  root 'static_pages#welcome_page'

  # Callbacks for omniauth to work
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :bank_accounts, except: [:index, :show] do
    resources :acct_transactions, except: [:index, :show],
                                  shallow: true
  end
end
