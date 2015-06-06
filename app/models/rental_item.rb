class RentalItem < ActiveRecord::Base

  validates :name_ja, presence: true, uniqueness: true
  validates :name_en, presence: true, uniqueness: true

  def to_s # aciveAdmin, simple_formで表示名を指定する
    self.name_ja
  end

end
