class CategoriesController < ApplicationController
  before_action :authorize_request, except: [:create, :index, :products]
  def create
    category_params = params[:category]
    create_nested_subcategories(category_params, parent_id: nil)
    render json: {"message": "Successfully created all the categories"}, status: :created
  end
  
  def index 
    category = Category.where(parent_id: nil)
    render json: category, Serializer: CategorySerializer
  end 

  def products
    category = Category.find(params[:category_id])
    products = category.products

    render json: { category: category.name, products: products }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end 

  private 
  def create_nested_subcategories(category_params, parent_id) 
    category = Category.find_or_create_by(name: category_params[:name], parent_id: parent_id)

    if category_params[:subcategories].present? 
      category_params[:subcategories].each do |x| 
        create_nested_subcategories(x,  category.id)
      end
    end
  end
end
