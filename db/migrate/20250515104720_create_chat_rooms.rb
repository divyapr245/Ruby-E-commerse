class CreateChatRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_rooms do |t|
      t.boolean :accepted
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
