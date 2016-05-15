class Stage < ActiveRecord::Base

  validates :name_ja, presence: true
  validates :name_ja, :uniqueness => true

  validates :enable_sunny, inclusion: {in: [false,true]}
  validates :enable_rainy, inclusion: {in: [false,true]}

  def to_s # aciveAdmin, simple_formで表示名を指定する
    self.name_ja
  end

  def self.by_weather( is_sunny )
    return where( enable_sunny: true) if is_sunny == true
    return where( enable_rainy: true) if is_sunny == false
  end
end
