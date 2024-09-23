class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :create, :verify_otp]

  def create
    @user = User.new(user_params.except(:otp, :otp_generated_at, :otp_verified))
    if @user.save
      UserMailer.with(user: @user, otp: @user.otp).otp_email.deliver_later
      render json: { message: 'OTP sent to your email. Please verify.' }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(user_name: params[:user_name])
    if user&.authenticate(params[:password])
      if user.otp_verified
        payload = { user_id: user.id }
        token = encode(payload)
        render json: { message: 'Login successful!', token: token, user_name: user.user_name, name: user.name }, status: :ok
      else
        render json: { error: 'OTP not verified. Please verify your OTP first.' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def verify_otp
    user = User.find_by(user_name: params[:user_name])
    
    if user && user.otp == params[:otp] && user.otp_generated_at > 20.minutes.ago
      user.update_column(:otp_verified, true) 
      render json: { message: 'OTP verified, registration complete.' }, status: :ok
    else
      render json: { message: 'Invalid or expired OTP' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_name, :email, :number, :password, :otp, :otp_generated_at, :otp_verified)
  end
end
