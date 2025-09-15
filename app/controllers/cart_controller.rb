class CartController < ApplicationController
  before_action :authorize_request

  def index 
    items = @current_user.cart_items.includes(:product)
  
    total_price = items.sum do |item|
      item.quantity * item.product.price.to_f
    end
  
    render json: {
      items: ActiveModelSerializers::SerializableResource.new(items, each_serializer: CartItemSerializer),
      total_price: total_price
    }, status: :ok
  end
  

  def sync
    cart = params[:items]

    cart.each do |item|
      product = Product.find_by(id: item[:id])
      next unless product
      
      user_cart = @current_user.cart_items.find_by(product_id: item[:id])

      if user_cart
        user_cart.update(quantity: user_cart.quantity + item[:quantity])
        @cart = user_cart
      else
       @cart =  @current_user.cart_items.create!(
          product: product,
          quantity: item[:quantity]
        )
      end
    end

    render json: @cart, Serializer: CartItemSerializer
  end 

  def destroy
    begin  
      product_id = params[:product_id] 
      user_cart = @current_user.cart_items.find_by(product_id: product_id)
      if user_cart
        removed_item = user_cart.destroy
        render json: {message: "Cart Item successfully removed"}
      else
        return render json: {error: "Product is not available"}, status: 404
      end
    rescue StandardError => e 
      render json: {error: e.message}

    end
  end

  def clear_all_cart 
    if @current_user.cart_items.count > 0 
      current_cart = @current_user.cart_items.destroy_all
      render json: {message: "cart items empty"}
    else
      render json: {message: "cart doesn't have items"}, status: :not_found
    end
  end

  
end
