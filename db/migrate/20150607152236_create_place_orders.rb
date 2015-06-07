class CreatePlaceOrders < ActiveRecord::Migration
  def change
    create_table :place_orders do |t|
      t.references :group, index: true, foreign_key: true
      t.integer :first
      t.integer :second
      t.integer :third

      t.timestamps null: false
    end
  end
end
