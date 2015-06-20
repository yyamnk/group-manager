ActiveAdmin.register StageOrder do


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
    column :fes_date_id do |order|
      FesDate.find(order.fes_date_id).date
    end
    column :is_sunny do |order|
      order.tenki
    end
    column :stage_first do  |order|
      order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
    end
    column :stage_second do |order|
      order.stage_second ? Stage.find(order.stage_second) : "未回答"
    end
    column :time
    actions
  end

  csv do
    column :id
    column :group_name do  |order|
      order.group.name
    end
    column :fes_date_id do |order|
      FesDate.find(order.fes_date_id).date
    end
    column :is_sunny do |order|
      order.tenki
    end
    column :stage_first do  |order|
      order.stage_first  ? Stage.find(order.stage_first)  : "未回答"
    end
    column :stage_second do |order|
      order.stage_second ? Stage.find(order.stage_second) : "未回答"
    end
    column :time
    column :own_equipment
    column :bgm
    column :camera_permittion
    column :loud_sound
  end
end
