ActiveAdmin.register_page "Chat" do
  content do
    panel "User Chat Messages" do
      table_for ChatMessage.includes(:user).all do
        column :user
        column :sender
        column :message
        column :created_at

        column "Actions" do |chat_message|
          link_to "Reply", "#", class: "reply-button", data: { user_id: chat_message.user_id }
        end
      end
    end

    panel "Reply to Messages" do
      div id: "chat-messages" do
        # This is where chat messages will be displayed
      end
      input type: "hidden", id: "user-id", value: ""
      input type: "text", id: "chat-input", placeholder: "Type your reply..."
      button id: "send-chat" do
        "Send Reply"
      end
    end
  end

  page_action :reply, method: :post do
    chat_message = ChatMessage.new(sender: 'admin', message: params[:message], user_id: params[:user_id])
    
    if chat_message.save
      render json: chat_message, status: :created
    else
      render json: { errors: chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end  

  # Add an action to fetch chat history
  page_action :history, method: :get do
    @messages = ChatMessage.where(user_id: params[:user_id])
    render json: @messages
  end
end
