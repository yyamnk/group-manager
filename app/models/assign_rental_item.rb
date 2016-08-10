class AssignRentalItem < ActiveRecord::Base
  belongs_to :rental_order
  belongs_to :rentable_item
end
