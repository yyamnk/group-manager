class RemoveIsOutsideFromPlace < ActiveRecord::Migration
  def change
    remove_column :places, :is_outside, :boolean
  end
end
