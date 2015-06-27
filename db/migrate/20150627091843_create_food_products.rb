class CreateFoodProducts < ActiveRecord::Migration
  def change
    create_table :food_products do |t|
      t.references :group, index: true, foreign_key: true
      t.string :name, null: false
      t.integer :num, null: false
      t.boolean :is_cooking, null:false

      t.timestamps null: false
    end
  end
end
