json.array!(@food_products) do |food_product|
  json.extract! food_product, :id, :group_id, :name, :num, :is_cooking
  json.url food_product_url(food_product, format: :json)
end
