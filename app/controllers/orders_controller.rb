class OrdersController < ApplicationController
  before_action :authorize_request

  def index 
    order_items = @current_user.orders
    if order_items.length > 0 
      render json: order_items, each_serializer: OrdersSerializer
    else 
      render json: {error: "No order is present"}, status: :not_found
    end
  end
  
  def create 
    if params[:cart].present?
      cart = params[:cart]
  
      ActiveRecord::Base.transaction do
        @order = @current_user.orders.create!(
          total_price: 500,
          status: params[:status]
        )
  
        cart.each do |x|
          @order.order_items.create!(
            product_id: x[:product][:id],                   
            quantity: x[:quantity],                
            price: x[:product][:price]                 
          )
        end
  
        render json: @order, serializer: OrdersSerializer
      end
    else 
      render json: { error: "Cart is empty" }, status: :unprocessable_entity
    end
  
  rescue => e 
    render json: { error: e.message }, status: :unprocessable_entity
  end
  
end
