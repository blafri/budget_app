Rails.application.routes.draw do
  root 'static_pages#welcome_page'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
end
