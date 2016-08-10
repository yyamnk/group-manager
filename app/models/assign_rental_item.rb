class AssignRentalItem < ActiveRecord::Base
  belongs_to :rental_order
  belongs_to :rentable_item

  validates_presence_of :rental_order_id, :rentable_item_id, :num
  validates :num, numericality: :only_integer
  validates :rental_order_id, uniqueness: {scope: [:rentable_item_id] }
  validate :valid_item  # カスタムバリデートを実行

  def valid_item
    return if rental_order.rental_item_id == rentable_item.stocker_item.rental_item_id
    # not equal
    errors.add(:rental_order_id, "希望物品と貸出物品は同一にしてください")
    errors.add(:rentable_item_id, "希望物品と貸出物品は同一にしてください")
  end
end
