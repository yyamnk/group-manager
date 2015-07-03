class AddColumnStartToFoodProduct < ActiveRecord::Migration
  def change
    add_column :food_products, :start, :string
  end
end
