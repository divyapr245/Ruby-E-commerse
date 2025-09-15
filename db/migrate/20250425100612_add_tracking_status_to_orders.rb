class AddTrackingStatusToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :tracking_status, :integer, default: 0
  end
end
