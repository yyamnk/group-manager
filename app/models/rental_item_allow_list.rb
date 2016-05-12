class RentalItemAllowList < ActiveRecord::Base
  belongs_to :rental_item
  belongs_to :group_category

  validates :rental_item_id   , presence: true
  validates :group_category_id, presence: true
  validates :rental_item_id, uniqueness: { scope: [:group_category_id] }
end
