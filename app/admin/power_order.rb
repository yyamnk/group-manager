ActiveAdmin.register PowerOrder do

  permit_params :group_id, :item, :power, :manufacturer, :model

  index do
    selectable_column
    id_column
    column "参加団体", :group
    column :item
    column :power
    column :manufacturer
    column :model
    column :updated_at
  end

  csv do
    column :id
    column :group do |order|
      order.group.name
    end
    column :item
    column :power
    column :manufacturer
    column :model
  end

end
