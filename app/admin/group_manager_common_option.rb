ActiveAdmin.register GroupManagerCommonOption do

  permit_params :cooking_start_time, :date_of_stool_test

  index do
    selectable_column
    id_column
    column :cooking_start_time
    column :date_of_stool_test
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
