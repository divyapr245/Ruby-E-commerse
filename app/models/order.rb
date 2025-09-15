class Order < ApplicationRecord
  belongs_to :account
  has_many :order_items
  has_many :notifications
  enum :tracking_status, {
    pending: 0,
    confirmed: 1,
    shipped: 2,
    in_transit: 3,
    out_for_delivery: 4,
    delivered: 5,
    cancelled: 6,
    failed: 7
  }
  after_save :create_notifications  
  after_update :send_email_notification_if_delivered

  def feedback_tokens
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
  
    self.order_items.map do |item|
      {
        product_name: item.product.description.slice(0, 10),
        token: verifier.generate({
          account_id: self.account_id,
          product_id: item.product_id,
          order_id: self.id
        })
      }
    end
  end
  

  private 

  def create_notifications 
    Notification.create(account_id: account_id,order_id: id , title: "Order ##{self.id} #{self.tracking_status}!", 
    message: "Your order ##{self.id}  is now '#{self.tracking_status}'.")
  end

  def send_email_notification_if_delivered
    if saved_change_to_tracking_status? && delivered?
      send_email_notification
    end
  end
  
  def send_email_notification 
    OrderMailer.example(self).deliver
  end


end
