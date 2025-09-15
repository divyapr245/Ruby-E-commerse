class MessagesController < ApplicationController
  before_action :authorize_request

  def create_message 
    chat_room = ChatRoom.find_by(sender_id: params[:message][:recipient_id], recipient_id: @current_user.id) ||  ChatRoom.find_by(sender_id: @current_user.id, recipient_id:  params[:message][:recipient_id])
    if chat_room.nil? 
      return render json: {error: "Chatroom not present for the sender and user"}, status: :unprocessable_entity
    else 
      message = Message.new_message(chat_room.id, @current_user.id, params[:message])
      render json: {message: message}, status: :ok
    end
  end

  def show 
    @chat_room = ChatRoom.find_by(id: params[:id])
    if @chat_room.nil? 
      return render json: {error: "Chatroom not present"}, status: :not_found
    end
    @messages = @chat_room.messages
    render json: @messages, status: :ok
  end

  def update
    @message = Message.find_by(id: params[:id], read: false)
  
    return render json: { error: "Message not found" }, status: :not_found unless @message
    return render json: { error: "Sender cannot update the message itself" }, status: :unauthorized if @message.account_id == @current_user.id
  
    if @message.update(read: true)
      render json: { message: "Message updated successfully" }, status: :ok
    else
      render json: { error: "Failed to update message" }, status: :unprocessable_entity
    end
  end

  def update_all_messages 
    @message = Message.where(chat_room_id: params[:chat_room_id], read: false).where.not(account_id: @current_user.id)
  
    return render json: { error: "Message not found" }, status: :not_found unless @message  
    if @message.update_all(read: true)
      render json: { message: "Message updated successfully" }, status: :ok
    else
      render json: { error: "Failed to update message" }, status: :unprocessable_entity
    end
  end
  
end
