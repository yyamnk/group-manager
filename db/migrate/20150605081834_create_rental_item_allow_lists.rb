class CreateRentalItemAllowLists < ActiveRecord::Migration
  def change
    create_table :rental_item_allow_lists do |t|
      t.references :rental_item, index: true, foreign_key: true
      t.references :group_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
