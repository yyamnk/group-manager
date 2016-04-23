class CreateStockerItems < ActiveRecord::Migration
  def change
    create_table :stocker_items do |t|
      t.references :rental_item, index: true, foreign_key: true
      t.references :stocker_place, index: true, foreign_key: true
      t.integer :num, null: false

      t.timestamps null: false
    end
  end
end
