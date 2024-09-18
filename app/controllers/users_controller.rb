class UsersController < ApplicationController
  require 'securerandom'
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # Set user session
      render json: { name: @user.name, user_name: @user.user_name }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user&.authenticate(params[:password])
      # Generate a token (you might want to use a more robust strategy for token generation)
      token = SecureRandom.hex(16)
      user.update(authentication_token: token) # Store the token in the database

      render json: { message: 'Login successful!', token: token }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def login_success
    if params[:search].present?
      @customers = current_user.customers.where('name LIKE ?', "%#{params[:search]}%")
    else
      @customers = current_user.customers
    end
    render json: @customers
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :password)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
