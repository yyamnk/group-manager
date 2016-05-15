class ChangeColumnToStage < ActiveRecord::Migration
  def up
    remove_column :stages, :is_sunny,     :boolean
    add_column    :stages, :enable_sunny, :boolean, :default => false
    add_column    :stages, :enable_rainy, :boolean, :default => false
    change_column :stages, :name_ja     , :string , :null    => false
  end

  def down
    add_column    :stages, :is_sunny,     :boolean
    remove_column :stages, :enable_sunny, :boolean, :default => nil
    remove_column :stages, :enable_rainy, :boolean, :default => nil
    change_column :stages, :name_ja     , :string , :null => true
  end
end
