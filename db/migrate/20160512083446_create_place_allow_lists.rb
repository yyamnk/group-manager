class CreatePlaceAllowLists < ActiveRecord::Migration
  def change
    create_table :place_allow_lists do |t|
      t.references :place, index: true, foreign_key: true
      t.references :group_category, index: true, foreign_key: true
      t.boolean :enable

      t.timestamps null: false
    end
  end
end
