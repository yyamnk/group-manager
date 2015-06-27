ActiveAdmin.register FoodProduct do

  permit_params :group_id, :name, :num, :is_cooking

  index do
    selectable_column
    id_column
    column :group
    column :name
    column :num
    column :is_cooking
    actions
  end

  csv do
    column :id
    column :group_name do |product|
      product.group.name
    end
    column :name
    column :num
    column :is_cooking
  end

end
