class StockerItem < ActiveRecord::Base
  belongs_to :rental_item
  belongs_to :stocker_place
  belongs_to :fes_year

  validates :rental_item_id, :stocker_place_id, :num, :fes_year_id, presence: true
  validates :num, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def to_s
    self.rental_item.to_s + ' (@' + self.stocker_place.to_s + ', 数量:' + self.num.to_s + ')'
  end

end
