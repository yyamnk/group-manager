class RemoveColumnToShop < ActiveRecord::Migration
  def change
    remove_column :shops, :closed, :string
  end
end
