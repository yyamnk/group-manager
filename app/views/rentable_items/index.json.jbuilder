json.array!(@rentable_items) do |rentable_item|
  json.extract! rentable_item, :id, :stocker_item_id, :stocker_place_id, :max_num
  json.url rentable_item_url(rentable_item, format: :json)
end
