ActiveAdmin.register RentalOrder do


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

  index do
    selectable_column
    id_column
    column :group
    column :rental_item
    column :num
  end

  csv do
    column :id
    column :group do |order|
      order.group.name
    end
    column :rental_item do |order|
      order.rental_item.name_ja
    end
    column :num
  end
end
