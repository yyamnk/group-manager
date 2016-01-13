json.array!(@stage_common_options) do |stage_common_option|
  json.extract! stage_common_option, :id, :group_id, :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content
  json.url stage_common_option_url(stage_common_option, format: :json)
end
