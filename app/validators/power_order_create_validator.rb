class PowerOrderCreateValidator < ActiveModel::Validator
  def validate(record) # 新規に追加されるのがrecord

    return if record.power.nil? # 空で入力されたら以降は無視

    # 保存されている使用電力の合計
    recorded_sum = PowerOrder.where(group_id: record.group_id).sum(:power)

    # ステージ団体は2500W, その他は1000W
    limit_power = stage?(record.group_id) ? 2500 : 1000

    # 追加される電力と合計して1000を超えたらエラー
    if (record.power + recorded_sum) > limit_power 
      msg = "団体が使用する電力の合計が#{limit_power}[W]を超えています (#{recorded_sum}[W]が申請済み)．"
      record.errors[:power] << msg
    end
  end

  def stage?(group_id)
    return true if 3 == Group.find(group_id).group_category_id
    return false
  end
end
