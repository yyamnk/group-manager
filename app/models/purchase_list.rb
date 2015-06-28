class PurchaseList < ActiveRecord::Base
  belongs_to :food_product
  belongs_to :shop
  belongs_to :fes_date
end
