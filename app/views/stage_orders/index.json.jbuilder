json.array!(@stage_orders) do |stage_order|
  json.extract! stage_order, :id, :group_id, :is_sunny, :fes_date_id, :stage_first, :stage_second, :time, :own_equipment, :bgm, :camera_permittion, :loud_sound
  json.url stage_order_url(stage_order, format: :json)
end
