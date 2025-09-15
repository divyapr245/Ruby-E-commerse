class ReviewsController < ApplicationController
  before_action :authorize_request, except:[:create]

  def create
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
    payload = verifier.verify(params[:reviews][:token])
    review = Review.new(
      account: Account.find_by(id: payload["account_id"]), 
      product_id: payload["product_id"],
      rating: params[:reviews][:rating],
      title: params[:reviews][:comment]
    )
  
    if review.save
      render json: { status: "created" }, status: :created
    else
      render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_product_reviews
    product_id = params[:product_id]
    product = Product.find_by(id: product_id)
  
    raise ActiveRecord::RecordNotFound, "Product not found" if product.nil?
  
    @reviews = product.reviews
    render json: @reviews ,each_serializer: ReviewSerializer
  rescue StandardError => e 
    render json: { error: e.message }, status: :not_found
  end
  
end
