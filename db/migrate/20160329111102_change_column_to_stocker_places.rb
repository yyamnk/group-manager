class ChangeColumnToStockerPlaces < ActiveRecord::Migration
  def change
    change_column :stocker_places, :is_available_fesdate, :boolean, null: false, default: true
  end
end
