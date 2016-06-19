namespace :food_product do

  task initialize_second_day_num: :environment do
    FoodProduct.update_all(second_day_num: 0)
  end

end
