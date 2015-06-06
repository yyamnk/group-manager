class Group < ActiveRecord::Base
  belongs_to :group_category
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :user, presence: true
  validates :activity, presence: true
  validates :group_category, presence: true

  def self.init_rental_order(id) # RentalOrderのレコードが無ければ数量0で登録する
    items_ids = RentalItem.all.pluck('id')
    items_ids.each{ |item_id|
      order = RentalOrder.new( group_id: id, rental_item_id: item_id, num: 0)
      order.save
    }
  end

end
