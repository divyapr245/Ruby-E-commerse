class Product < ApplicationRecord
     has_and_belongs_to_many :categories
     belongs_to :brand
     has_many :cart_items
     has_many :reviews
end
