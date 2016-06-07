class AddColumnToConfigUserPermission < ActiveRecord::Migration
  def change
    add_column :config_user_permissions, :panel_partial, :string, null: false
  end
end
