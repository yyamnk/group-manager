json.array!(@stocker_items) do |stocker_item|
  json.extract! stocker_item, :id, :rental_item_id, :stocker_place_id, :num
  json.url stocker_item_url(stocker_item, format: :json)
end
