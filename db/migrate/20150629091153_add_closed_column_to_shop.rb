class AddClosedColumnToShop < ActiveRecord::Migration
  def change
    add_column :shops, :is_closed_sun, :boolean, default: false
    add_column :shops, :is_closed_mon, :boolean, default: false
    add_column :shops, :is_closed_tue, :boolean, default: false
    add_column :shops, :is_closed_wed, :boolean, default: false
    add_column :shops, :is_closed_thu, :boolean, default: false
    add_column :shops, :is_closed_fri, :boolean, default: false
    add_column :shops, :is_closed_sat, :boolean, default: false
    add_column :shops, :is_closed_holiday, :boolean, default: false
  end
end
