ActiveAdmin.register Stage do

  permit_params :name_ja, :name_en, :enable_sunny, :enable_rainy
  
    index do
    id_column

    column :name_ja
    column :name_en
    column :enable_sunny
    column :enable_rainy

    actions
  end
end
