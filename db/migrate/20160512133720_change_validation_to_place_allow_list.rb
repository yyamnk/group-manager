class ChangeValidationToPlaceAllowList < ActiveRecord::Migration
  def up 
    change_column :place_allow_lists, :place_id,          :integer, null:false
    change_column :place_allow_lists, :group_category_id, :integer, null:false
    change_column :place_allow_lists, :enable,            :boolean, default:false
    add_index     :place_allow_lists, [:place_id,:group_category_id], :unique=>true
  end

  def down
    change_column :place_allow_lists, :place_id,          :integer, null:true, default:nil
    change_column :place_allow_lists, :group_category_id, :integer, null:true, default:nil
    change_column :place_allow_lists, :enable,            :boolean, default:nil
    remove_index  :place_allow_lists, [:place_id,:group_category_id]
  end
end
