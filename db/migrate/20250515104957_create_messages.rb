class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :account, null: false, foreign_key: true
      t.references :chat_room, null: false, foreign_key: true
      t.string :time

      t.timestamps
    end
  end
end
