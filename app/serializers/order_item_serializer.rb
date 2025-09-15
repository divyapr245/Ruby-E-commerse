class OrderItemSerializer < ActiveModel::Serializer
    attributes :id, :quantity, :price, :product
  
  end