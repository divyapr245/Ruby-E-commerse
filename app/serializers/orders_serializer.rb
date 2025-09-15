class OrdersSerializer < ActiveModel::Serializer
  attributes :id,:total_price, :order_items
  has_many :order_items, serializer: OrderItemSerializer
end