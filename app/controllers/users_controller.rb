class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :create]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user&.authenticate(params[:password])
      payload = { user_id: user.id }
      token = encode(payload)
      render json: { message: 'Login successful!', token: token , user_name: user.user_name, name: user.name}, status: :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :email, :number, :password)
  end
end
