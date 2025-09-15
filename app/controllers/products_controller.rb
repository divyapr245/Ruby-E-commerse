class ProductsController < ApplicationController
  before_action :authorize_request, except: [:show]

  def show  
    product = Product.find_by(id: params[:id])
    if product 
      render json: {product: product}, status: :ok
    else 
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def show_recommended_products 
    category_ids = Category.joins(products: :cart_items)
    .where(cart_items: { account_id: @current_user.id })
    .distinct
    .pluck(:id)

    similar_products = Product.joins(:categories)
      .where(categories: { id: category_ids })
      .where.not(id: @current_user.cart_items.select(:product_id))
      .distinct

    random_products = similar_products.sample(10)
    if similar_products 
      render json: {product: random_products}, status: :ok
    else 
      render json: { error: 'Product not found' }, status: :not_found
    end

  end
end
