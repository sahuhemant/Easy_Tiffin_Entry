Rails.application.routes.draw do
  get 'tiffins/show'
  resources :users
  root 'users#index'  # Root page for the login/register buttons

  # Routes for user registration and login
   post '/register', to: 'users#create'
   get '/login_success', to: 'users#login_success'
   # Routes for login
   get '/login', to: 'users#login'
   post '/login', to: 'users#login'
   get '/login_success', to: 'users#login_success'
   resources :customers, only: [:new, :create, :index]
    get '/tiffin', to: 'tiffins#show'
    resources :customers do
      resources :tiffins, only: [:index, :new, :create]
    end
    
    

end
