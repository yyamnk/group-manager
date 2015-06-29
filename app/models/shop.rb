class Shop < ActiveRecord::Base

  validates_presence_of :name, :kana, :tel

  # tel -> 半角数字とハイフンのみ, [4444-22-4444, for 固定] )
  validates :tel,     format: { with: /(\A\d{4}-\d{2}-\d{4})+\z/i }

  # true or falseを指定
  validates :is_closed_sun    , inclusion: {in: [true, false]}
  validates :is_closed_mon    , inclusion: {in: [true, false]}
  validates :is_closed_tue    , inclusion: {in: [true, false]}
  validates :is_closed_wed    , inclusion: {in: [true, false]}
  validates :is_closed_thu    , inclusion: {in: [true, false]}
  validates :is_closed_fri    , inclusion: {in: [true, false]}
  validates :is_closed_sat    , inclusion: {in: [true, false]}
  validates :is_closed_holiday, inclusion: {in: [true, false]}

  # 休みでないもの
  scope :open_sun, -> { where( is_closed: 'false') }
  scope :open_sat, -> { where( is_closed: 'false') }
end
