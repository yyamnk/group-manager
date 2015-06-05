class RentalItemAllowList < ActiveRecord::Base
  belongs_to :rental_item
  belongs_to :group_category
end
