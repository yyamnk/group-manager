class DeleteColumnToFoodProduct < ActiveRecord::Migration
  def up
    remove_column :food_products, :start, :string
  end
  def down
    add_column    :food_products, :start, :string
  end
end
