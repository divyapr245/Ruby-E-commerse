class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :subcategories
end
