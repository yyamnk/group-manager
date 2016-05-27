class CreateConfigUserPermissions < ActiveRecord::Migration
  def change
    create_table :config_user_permissions do |t|
      t.string :form_name, null: false
      t.boolean :is_accepting, default: false
      t.boolean :is_only_show, default: false

      t.timestamps null: false
    end
  end
end
