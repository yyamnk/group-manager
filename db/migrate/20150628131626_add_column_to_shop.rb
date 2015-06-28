class AddColumnToShop < ActiveRecord::Migration
  def change
    add_column :shops, :kana, :string
    add_column :shops, :closed, :string
  end
end
