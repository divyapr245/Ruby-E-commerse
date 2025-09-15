class AddFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :image_url, :string
    add_column :products, :description, :text
    add_column :products, :price, :string
  end
end
