class AddClosedColumnToShop < ActiveRecord::Migration
  def change
    add_column :shops, :is_closed_sun, :boolean
    add_column :shops, :is_closed_mon, :boolean
    add_column :shops, :is_closed_tue, :boolean
    add_column :shops, :is_closed_wed, :boolean
    add_column :shops, :is_closed_thu, :boolean
    add_column :shops, :is_closed_fri, :boolean
    add_column :shops, :is_closed_sat, :boolean
    add_column :shops, :is_closed_holiday, :boolean
  end
end
