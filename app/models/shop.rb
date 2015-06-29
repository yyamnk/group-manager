class Shop < ActiveRecord::Base

  serialize :closed # 配列を格納できるようにする.
  validates_presence_of :name, :kana, :tel

  # tel -> 半角数字とハイフンのみ, [4444-22-4444, for 固定] )
  validates :tel,     format: { with: /(\A\d{4}-\d{2}-\d{4})+\z/i }

  # 日曜日が休みでないもの
  # scope :enable_sun, -> {where.not( closed: '0')}

end
