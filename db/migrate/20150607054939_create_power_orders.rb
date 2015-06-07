class CreatePowerOrders < ActiveRecord::Migration
  def change
    create_table :power_orders do |t|
      t.references :group, index: true, foreign_key: true, null: false
      t.string :item, null: false
      t.integer :power, nul: false

      t.timestamps null: false
    end
  end
end
