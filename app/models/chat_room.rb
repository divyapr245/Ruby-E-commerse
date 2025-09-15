class ChatRoom < ApplicationRecord
  belongs_to :sender, class_name: 'Account'
  belongs_to :recipient, class_name: 'Account'
  has_many :messages
  after_create :create_notification
  after_update :send_sender_notification
  def includes_user?(user)
    sender == user || recipient == user
  end
  private 
  def create_notification
    ChatRequestNotification.create(account_id: recipient_id, chat_room_id: id, title: "New Chat Request", message: "You have a new chat request from #{sender.email}")
  end

  def send_sender_notification
    if accepted?
      ChatRequestNotification.create(account_id: sender_id, chat_room_id: id, title: "Chat Request Accepted", message: "Your chat request has been accepted by #{recipient.email}")
    end
  end

end
