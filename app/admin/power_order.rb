ActiveAdmin.register PowerOrder do

  index do
    selectable_column
    id_column
    column "参加団体", :group
    column :item
    column :power
    column :updated_at
  end

  csv do
    column :id
    column :group do |order|
      order.group.name
    end
    column :item
    column :power
  end

end
