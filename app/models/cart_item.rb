class CartItem < ApplicationRecord
  belongs_to :account
  belongs_to :product
  validates :quantity, numericality: { greater_than: 0 }
end
