class AddBrandToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :brand, foreign_key: true
    add_column :products, :product_description, :text
  end
end
