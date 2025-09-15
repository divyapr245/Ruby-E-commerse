class Message < ApplicationRecord
  belongs_to :account
  belongs_to :chat_room
  #to create new_messages
  def self.new_messages 
    
  end
  def self.new_message(chat_room_id, sender_id, params)
    message = Message.create!(chat_room_id: chat_room_id, account_id: sender_id, body: params[:body], time: Time.now())
    ActionCable.server.broadcast("chat_#{params[:recipient_id]}#{sender_id}", message)
    ActionCable.server.broadcast("chat_#{params[sender_id]}#{:recipient_id}", message)
    data = REDIS_CLIENT.hgetall("presence:#{params[:recipient_id]}")
    status = data["status"]
    room_id = data["room_id"]
    if status == "offline"
      sender = Account.find_by(id: sender_id)
      notification = ChatRequestNotification.create!(chat_room_id: room_id, account_id: params[:recipient_id], title: "New Message from #{sender.email}", message: params[:body])
      serialized = ChatRequestNotificationsSerializer.new(notification).as_json
      ActionCable.server.broadcast("user_#{params[:recipient_id]}", {type: "ChatNotification", title: "New Message from #{sender.email}", body: params[:body], notification_data: serialized})
      ActionCable.server.broadcast("user_#{params[:recipient_id]}", {type: "Message", message: message})

    end
    return message
  end

end
