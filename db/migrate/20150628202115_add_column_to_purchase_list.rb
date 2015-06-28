class AddColumnToPurchaseList < ActiveRecord::Migration
  def change
    add_column :purchase_lists, :items, :string, null: false
  end
end
