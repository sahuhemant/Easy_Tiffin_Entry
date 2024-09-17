class UsersController < ApplicationController

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
      render json: { message: 'Login successful!', user_name: user.name }, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def login_success
    if params[:search].present?
      @customers = Customer.where('name LIKE ?', "%#{params[:search]}%")
    else
      @customers = Customer.all
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :password)
  end
end
