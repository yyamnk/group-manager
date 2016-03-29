class RentableItem < ActiveRecord::Base
  belongs_to :stocker_item
  belongs_to :stocker_place
end
