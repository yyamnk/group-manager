class FoodProduct < ActiveRecord::Base
  belongs_to :group

  validates_presence_of :group_id, :name, :num
  validates_numericality_of :group_id, :num
  # boolean型をチェック. presence_of ではfalseでエラーになってしまう
  validates :is_cooking, inclusion: {in: [true, false]}

  def disp_cooking
    disp = self.is_cooking ? '調理あり' : '調理なし(提供のみ)'
    return disp
  end

end
