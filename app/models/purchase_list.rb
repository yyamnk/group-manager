class PurchaseList < ActiveRecord::Base
  belongs_to :food_product
  belongs_to :shop
  belongs_to :fes_date

  validates_presence_of :food_product_id, :shop_id, :fes_date_id, :items

  def fresh
    return self.is_fresh ? "生鮮食品" : "保存食品"
  end
end
