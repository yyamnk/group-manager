json.array!(@shops) do |shop|
  json.extract! shop, :id, :name, :tel, :time_weekdays, :time_sat, :time_sun, :time_holidays
  json.url shop_url(shop, format: :json)
end
