class FoodProduct < ActiveRecord::Base
  belongs_to :group

  validates_presence_of :group_id, :name, :num
  validates_numericality_of :group_id, :num
end
