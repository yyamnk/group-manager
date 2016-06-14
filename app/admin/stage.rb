ActiveAdmin.register Stage do

    index do
    id_column

    column :name_ja
    column :name_en
    column :enable_sunny
    column :enable_rainy

    actions
  end
end
