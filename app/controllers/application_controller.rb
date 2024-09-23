class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include JsonWebToken

  before_action :authenticate_user

  def current_user
    @current_user
  end

  private

  def authenticate_user
    # Skip token authentication for admin routes and non-API HTML requests
    if request.path.start_with?('/admin') || request.format.html?
      return true
    end

    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode(token)

    if decoded_token
      user_id = decoded_token['user_id']
      @current_user = User.find_by(id: user_id)

      # If no user is found, render unauthorized error
      unless @current_user
        render json: { error: 'User not found' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end
end
