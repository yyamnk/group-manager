class PlaceOrder < ActiveRecord::Base
  belongs_to :group
  validate :select_different_stage

  def select_different_stage
    return if first.nil? & second.nil? & third.nil? # 全てnil(初期値)なら無効
    if [first, second, third].uniq.size < 3
        errors.add( :first , "候補が重複しています。")
        errors.add( :second, "候補が重複しています。")
        errors.add( :third , "候補が重複しています。")
    end
  end
end
