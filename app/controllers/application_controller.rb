class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include JsonWebToken

  before_action :authenticate_user

  def current_user
    @current_user
  end

  private

  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode(token)
    if decoded_token
      user_id = decoded_token['user_id']
      @current_user = User.find_by(id: user_id)
    else
      render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
  end
end
