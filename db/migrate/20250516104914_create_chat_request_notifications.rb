class CreateChatRequestNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_request_notifications do |t|
      t.timestamps
    end
  end
end
