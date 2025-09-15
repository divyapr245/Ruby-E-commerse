class Account < ApplicationRecord
  has_secure_password
  has_many :cart_items, dependent: :destroy
  has_many :orders
  has_many :notifications
  has_many :chat_request_notifications, -> { where(type: 'ChatRequestNotification') }, class_name: 'Notification'
  has_many :order_notifications, -> { where(type: 'OrderNotification') }, class_name: 'Notification'

  has_many :reviews
  has_many :messages
  has_many :chatrooms_as_sender, class_name: 'ChatRoom', foreign_key: :sender_id
  has_many :chatrooms_as_recipent, class_name: 'ChatRoom', foreign_key: :recipient_id
  
  def chatrooms
    ChatRoom.where("sender_id = ? OR recipient_id = ?", id, id)
  end
end
