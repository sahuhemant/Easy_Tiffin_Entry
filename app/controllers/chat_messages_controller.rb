class ChatMessagesController < ApplicationController
  
  def index
    @messages = ChatMessage.where(user: @current_user)
    render json: @messages
  end

  def create
    @message = ChatMessage.new(message_params)
    @message.user = @current_user
    @message.sender = @current_user ? 'user' : 'admin'

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end
 
  def history
    user_id = params[:user_id]
    @messages = ChatMessage.where(user_id: user_id)
    render json: @messages
  end

  private

  def message_params
    params.require(:chat_message).permit(:message, :sender)
  end
end
