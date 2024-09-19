class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: :login

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { name: @user.name, user_name: @user.user_name }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user&.authenticate(params[:password])
      payload = { user_id: user.id }
      token = encode(payload)
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
