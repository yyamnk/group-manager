class RemoveTimeFromStageOrder < ActiveRecord::Migration
  def change
    remove_column :stage_orders, :time, :string
  end
end
