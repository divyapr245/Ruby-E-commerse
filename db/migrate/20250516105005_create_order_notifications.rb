class CreateOrderNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :order_notifications do |t|
      t.timestamps
    end
  end
end
