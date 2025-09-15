ActiveAdmin.register Order do
  # Specify parameters which should be permitted for assignment
  permit_params :account_id, :total_price, :status, :tracking_status

  # or consider:
  #
  # permit_params do
  #   permitted = [:account_id, :total_price, :status, :tracking_status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :account
  filter :total_price
  filter :status
  filter :created_at
  filter :updated_at
  filter :tracking_status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :account
    column :total_price
    column :status
    column :created_at
    column :updated_at
    column :tracking_status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :account
      row :total_price
      row :status
      row :created_at
      row :updated_at
      row :tracking_status
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :account
      f.input :total_price
      f.input :status
      f.input :tracking_status
    end
    f.actions
  end
end
