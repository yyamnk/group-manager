class ChangeColumnsToPowerOrders < ActiveRecord::Migration
  def change
    change_column_default :power_orders, :manufacturer, nil
    change_column_default :power_orders, :model, nil
  end
end
