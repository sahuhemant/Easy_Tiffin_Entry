Rails.application.routes.draw do
  root 'users#index'

  # Routes for user registration
  get 'register', to: 'users#new'
  post 'register', to: 'users#create'

  # Routes for user login
  get 'login', to: 'users#login'  # Render login page (not used by the React app)
  post 'login', to: 'users#login'

  # Other routes
  get '/login_success', to: 'users#login_success'
  resources :users
  resources :customers, only: [:new, :create, :index]
  resources :customers do
    resources :tiffins, only: [:index, :new, :create, :edit, :update]
  end
  get 'tiffin', to: 'tiffins#show'
end
