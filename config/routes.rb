Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/admin/chat/history', to: 'admin/chat#history'

  # namespace :admin do
  #   get 'dashboard', to: 'admin_dashboard#index'
  # end

  # Resister User controller routes
  post 'register', to: 'users#create'
  post '/verify_otp', to: 'users#verify_otp'
  post 'login', to: 'users#login'

  # Customer
  resources :customers, only: [:index, :create]
  post 'customer_payment_detail', to: 'customers#customer_payment_detail'
  
  # Customer Tiffin
  resources :customers do
    resources :tiffins, only: [:index, :create, :update, :destroy]
  end

  # Stripe
  namespace :payment do
    post 'stripe/charge', to: 'stripe#charge'
  end

  # OTP
  post 'send_otp', to: 'users#send_otp'
  devise_for :users
  post 'generate_otp', to: 'users#generate_otp'
  post 'verify_otp', to: 'users#verify_otp'

  # chat_message
  resources :chat_messages, only: [:index, :create]

  resources :chat_messages do
    collection do
      get :history
    end
  end
  
end

