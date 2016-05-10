class RenameTimeToStageOrder < ActiveRecord::Migration
  def change
    rename_column :stage_orders, :time, :time_interval
  end
end
