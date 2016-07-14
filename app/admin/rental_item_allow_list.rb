ActiveAdmin.register RentalItemAllowList do
  permit_params do
    params = [:rental_item, :group_category_id] if current_user.role_id==1
    params
  end

  index do 
    selectable_column
    id_column
    column :rental_item
    column :group_category
    actions
  end





  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
