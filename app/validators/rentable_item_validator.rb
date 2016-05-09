class RentableItemValidator < ActiveModel::Validator

  def validate(record)
    if record.stocker_item.blank? || record.max_num.blank?
      return
    elsif record.max_num > record.stocker_item.num
      msg = '貸出可能数が登録済みの在庫数を超えています'
      record.errors[:max_num] << msg
    end
  end

end
