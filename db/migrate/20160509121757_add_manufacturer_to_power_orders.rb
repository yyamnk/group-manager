class AddManufacturerToPowerOrders < ActiveRecord::Migration
  def change
    add_column :power_orders, :manufacturer, :string, null: false, default: 'No Data'
    add_column :power_orders, :model, :string, null: false, default: 'No Data'
  end
end
