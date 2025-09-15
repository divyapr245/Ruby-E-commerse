ActiveAdmin.register Category do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :parent_id, :image_url, :is_featured

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :parent_id, :image_url]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  # filter :id
  # filter :name
  # filter :parent
  # filter :created_at
  # filter :updated_at
  # filter :image_url

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :parent
    column :created_at
    column :updated_at
    column :image_url
    column :is_featured
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :parent
      row :created_at
      row :updated_at
      row :image_url
      row :is_featured
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :parent, :as => :select, :collection => Category.where(parent_id: nil)
      f.input :image_url
      f.input :is_featured
    end
    f.actions
  end
end
