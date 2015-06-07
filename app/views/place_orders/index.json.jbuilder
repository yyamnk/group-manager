json.array!(@place_orders) do |place_order|
  json.extract! place_order, :id, :group_id, :first, :second, :third
  json.url place_order_url(place_order, format: :json)
end
