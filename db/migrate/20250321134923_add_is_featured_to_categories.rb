class AddIsFeaturedToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :is_featured, :boolean, default: false
  end
end
