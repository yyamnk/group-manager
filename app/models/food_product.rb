class FoodProduct < ActiveRecord::Base
  belongs_to :group

  validates_presence_of :group_id, :name, :num
  validates_numericality_of :group_id, :num
  # boolean型をチェック. presence_of ではfalseでエラーになってしまう
  validates :is_cooking, inclusion: {in: [true, false]}
end
