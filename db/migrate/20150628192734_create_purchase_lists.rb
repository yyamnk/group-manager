class CreatePurchaseLists < ActiveRecord::Migration
  def change
    create_table :purchase_lists do |t|
      t.references :food_product, index: true, foreign_key: true
      t.references :shop, index: true, foreign_key: true
      t.references :fes_date, index: true, foreign_key: true
      t.boolean :is_fresh

      t.timestamps null: false
    end
  end
end
