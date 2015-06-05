class RentalOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :rental_item
end
