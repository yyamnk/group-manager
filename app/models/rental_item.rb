class RentalItem < ActiveRecord::Base

  validates :name_ja, presence: true, uniqueness: true
  validates :name_en, presence: true, uniqueness: true

  def to_s # aciveAdmin, simple_formで表示名を指定する
    self.name_ja
  end

  def self.permitted(group_id) # 許可された貸出物品を返す
    category = Group.find(group_id).group_category # 団体のカテゴリ
    # 許可された物品のid
    allowed_ids = RentalItemAllowList.where(group_category_id: category).pluck('rental_item_id')
    where(id: allowed_ids)
  end

  def self.init_rental_order(id) # RentalOrderのレコードが無ければ数量0で登録する
    group_ids = Group.all.pluck('id')
    group_ids.each{ |group_id|
      order = RentalOrder.new( group_id: group_id, rental_item_id: id, num: 0)
      order.save
    }
  end

end
