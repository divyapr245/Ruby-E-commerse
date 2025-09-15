class Category < ApplicationRecord
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Category", optional: true
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :products
  accepts_nested_attributes_for :subcategories
end
