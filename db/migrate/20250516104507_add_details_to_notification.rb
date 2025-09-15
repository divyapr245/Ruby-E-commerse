class AddDetailsToNotification < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :type, :string
    add_reference :notifications, :chat_room, foreign_key: true
  end
end
