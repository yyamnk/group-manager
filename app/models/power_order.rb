class PowerOrder < ActiveRecord::Base
  belongs_to :group

  validates :group_id, :item, :power, presence: true # 必須項目
  validates :power, numericality: { # 整数のみ, [1-1000]
    only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000,
  }

  validates_with PowerOrderCreateValidator, on: :create
  validates_with PowerOrderUpdateValidator, on: :update

end
