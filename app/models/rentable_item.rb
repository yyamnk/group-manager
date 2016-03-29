class RentableItem < ActiveRecord::Base
  belongs_to :stocker_item
  belongs_to :stocker_place

  validates :stocker_item_id, :stocker_place_id, :max_num, presence: true
  validates :max_num, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end
