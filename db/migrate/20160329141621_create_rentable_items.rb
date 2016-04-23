class CreateRentableItems < ActiveRecord::Migration
  def change
    create_table :rentable_items do |t|
      t.references :stocker_item, index: true, foreign_key: true
      t.references :stocker_place, index: true, foreign_key: true
      t.integer :max_num, null: false

      t.timestamps null: false
    end
  end
end
