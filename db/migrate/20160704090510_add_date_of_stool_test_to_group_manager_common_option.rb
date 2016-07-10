class AddDateOfStoolTestToGroupManagerCommonOption < ActiveRecord::Migration
  def change
    add_column :group_manager_common_options, :date_of_stool_test, :string
  end
end
