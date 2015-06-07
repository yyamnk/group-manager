class PowerOrderUpdateValidator < ActiveModel::Validator
  def validate(record) # 更新されるのがrecord

    return if record.power.nil? # 空で入力されたら以降は無視

    # 保存されている使用電力の合計 (これには更新前のレコードが含まれる).
    all = PowerOrder.where(group_id: record.group_id).sum(:power)

    # 更新前の電力量を引く
    all_without_updated = all - PowerOrder.find(record.id).power

    # 追加される電力と合計して1000を超えたらエラー
    if (all_without_updated + record.power) > 1000
      msg = "団体が使用する電力の合計が1000[W]を超えています (#{all_without_updated}[W]が申請済み)．"
      record.errors[:power] << msg
    end
  end
end
