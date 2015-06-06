json.array!(@rental_orders) do |rental_order|
  json.extract! rental_order, :id, :group_id, :rental_item_id, :num
  json.url rental_order_url(rental_order, format: :json)
end
