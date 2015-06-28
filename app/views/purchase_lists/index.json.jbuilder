json.array!(@purchase_lists) do |purchase_list|
  json.extract! purchase_list, :id, :food_product_id, :shop_id, :fes_date_id, :is_fresh
  json.url purchase_list_url(purchase_list, format: :json)
end
