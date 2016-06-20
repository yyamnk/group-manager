class ChangeColumnToFoodProduct < ActiveRecord::Migration
 def up
   rename_column :food_products, :num, :first_day_num
   change_column :food_products, :first_day_num,  :integer, :default => 0
   add_column    :food_products, :second_day_num, :integer, :default => 0
 end

 def down
   rename_column :food_products, :first_day_num,   :num
   change_column :food_products, :num,  :integer, :default => 0
   remove_column :food_products, :second_day_num, :integer
 end

end
