class ChatRequestNotificationsSerializer < ActiveModel::Serializer
  attributes :id, :account_id, :order_id, :title, :message, :read,  :chat_room
end