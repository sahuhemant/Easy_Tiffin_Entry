Rails.application.routes.draw do
  # Resister
  post 'register', to: 'users#create'

  # Login
  post 'login', to: 'users#login'

  # Customer
  resources :customers, only: [:index, :create]
  
  # Customer Tiffin
  resources :customers do
    resources :tiffins, only: [:index, :create, :update, :destroy]
  end

  # Stripe
  namespace :payment do
    post 'stripe/charge', to: 'stripe#charge'
  end  
end

