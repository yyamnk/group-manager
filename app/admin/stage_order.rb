ActiveAdmin.register StageOrder do

  permit_params :group_id, :fes_date_id, :is_sunny, :stage_first, :stage_second, :time, :own_equipment, :bgm, :camera_permittion, :loud_sound

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
