Rails.application.routes.draw do
  root 'users#index'

  # Routes for user registration
  get 'register', to: 'users#new'
  post 'register', to: 'users#create'

  # Routes for user login
  post 'login', to: 'users#login'

  # Routes for user login success
  get '/login_success', to: 'users#login_success'

  # Resources
  resources :customers, only: [:index, :create] do
    resources :tiffins, only: [:index, :create, :update, :destroy]
  end

  # Additional routes for users if needed
  resources :users, only: [:index, :show, :create, :update, :destroy]
end
