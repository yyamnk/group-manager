class StockerItem < ActiveRecord::Base
  belongs_to :rental_item
  belongs_to :stocker_place

  validates :rental_item_id, :stocker_place_id, :num, presence: true
  validates :num, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end
