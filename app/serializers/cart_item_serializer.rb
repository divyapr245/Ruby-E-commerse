class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product

  def product
    {
      id: object.product.id,
      image_url: object.product.image_url,
      description: object.product.description,
      price: object.product.price
    }
  end
  
end