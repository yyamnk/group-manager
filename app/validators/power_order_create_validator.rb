class PowerOrderCreateValidator < ActiveModel::Validator
  def validate(record) # 新規に追加されるのがrecord

    return if record.power.nil? # 空で入力されたら以降は無視

    # 保存されている使用電力の合計
    recorded_sum = PowerOrder.where(group_id: record.group_id).sum(:power)

    # 追加される電力と合計して1000を超えたらエラー
    if (record.power + recorded_sum) > 1000
      msg = "団体が使用する電力の合計が1000[W]を超えています (#{recorded_sum}[W]が申請済み)．"
      record.errors[:power] << msg
    end
  end
end
