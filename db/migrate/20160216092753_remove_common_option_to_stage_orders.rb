class RemoveCommonOptionToStageOrders < ActiveRecord::Migration
  def change
    remove_column :stage_orders, :own_equipment
    remove_column :stage_orders, :bgm
    remove_column :stage_orders, :camera_permittion
    remove_column :stage_orders, :loud_sound
  end
end
