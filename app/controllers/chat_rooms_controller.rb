class ChatRoomsController < ApplicationController
  before_action :authorize_request

  def index 
    chat_rooms = @current_user.chatrooms.where(accepted: true).includes(:messages)
  
    chat_data = chat_rooms.map do |chat_room|
      # Get unread messages for current user
      unread_messages = chat_room.messages.where(read: false).where.not(account_id: @current_user.id)
  
      {
        id: chat_room.id,
        sender_id: chat_room.sender_id,
        recipient_id: chat_room.recipient_id,
        unread_count: unread_messages.count,
        last_unread_message: unread_messages.last
      }
    end
  
    render json: chat_data
  end
  

  def create 
    if params[:recipient_id].present?
      recipient = Account.find(params[:recipient_id])
      chatroom = ChatRoom.find_by(sender_id: recipient.id, recipient_id: @current_user.id) ||
             ChatRoom.find_by(sender_id: @current_user.id, recipient_id: recipient.id)

      if chatroom.nil?
        chatroom = ChatRoom.create!(
          sender_id: @current_user.id,
          recipient_id: recipient.id,
          accepted: false
        )
      end
        render json: {
          chatroom_id: chatroom.id,
          status: chatroom.accepted? ? "delivered" : "waiting_for_acceptance"
        }, status: :ok
    else 
      render json: {"error": "Plase provide valid params"}, status: :unprocessable_entity
    end
  end

  def accept_request 
    chatroom = ChatRoom.find_by(id: params[:id])
    if chatroom.nil?
      render json: {"error": "Chat room not found"}, status: :not_found
    else
      chatroom.update(accepted: true)
      render json: {message: "Chat room accepted"}, status: :ok
    end
  end

  def presence
    user_id = params[:id]
    data = REDIS_CLIENT.hgetall("presence:#{user_id}")
    render json: {
      user_id: user_id,
      current_status: data["status"] || "offline",
      last_active_at: data["last_active_at"]
    }
  end


end
