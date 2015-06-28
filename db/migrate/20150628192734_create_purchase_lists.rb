class CreatePurchaseLists < ActiveRecord::Migration
  def change
    create_table :purchase_lists do |t|
      t.references :food_product, index: true, foreign_key: true, null: false
      t.references :shop        , index: true, foreign_key: true, null: false
      t.references :fes_date    , index: true, foreign_key: true, null: false
      t.boolean :is_fresh

      t.timestamps null: false
    end
  end
end
