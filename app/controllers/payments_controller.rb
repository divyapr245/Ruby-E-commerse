class PaymentsController < ApplicationController
  def create_payment_intent
    total_amount = params[:amount]
    begin 
      intent = Stripe::PaymentIntent.create({
        amount: total_amount,
        currency: 'usd',
      })

      render json: {client_secret: intent.client_secret}
    rescue Stripe::StripeError => e
      render json: {error: e.mesage}, status: :unprocessable_entity
    end    
  end
end
