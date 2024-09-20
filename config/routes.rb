Rails.application.routes.draw do
  root 'users#index'

  # Routes for user registration
  get 'register', to: 'users#new'
  post 'register', to: 'users#create'

  # Routes for user login
  post 'login', to: 'users#login'

  # Routes for user login success
  get '/login_success', to: 'users#login_success'

  # Nested resources for users and customers
    resources :users, only: [:index, :show, :create, :update, :destroy] do
      resources :customers, only: [:index, :create] 
    end
    
    resources :customers do
      resources :tiffins, only: [:index, :create, :update, :destroy]
    end
end

