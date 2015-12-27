ActiveAdmin.register FesDate do


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
  permit_params :day, :days_num, :date, :fes_year_id

  index do
    selectable_column
    id_column
    column :fes_year
    column :day
    column :days_num
    actions
  end
end
