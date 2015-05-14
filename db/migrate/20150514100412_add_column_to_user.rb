class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :get_notice, :boolean, null: false, default: false
  end
end
