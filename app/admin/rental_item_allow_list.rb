ActiveAdmin.register RentalItemAllowList do


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
  #
  permit_params :rental_item_id, :group_category_id

  index do
    selectable_column
    id_column
    column :group_category_id do |order|
      order.group_category
    end
    column :rental_item
    actions
  end

end
