class FoodProduct < ActiveRecord::Base
  belongs_to :group
  has_many :purchase_list

  validates_presence_of :group_id, :name, :num
  validates_presence_of :start, if: :is_cooking # self.is_cooking == true でstartが必須
  validates_numericality_of :group_id, :num
  # boolean型をチェック. presence_of ではfalseでエラーになってしまう
  validates :is_cooking, inclusion: {in: [true, false]}

  def to_s
    self.name
  end

  def disp_cooking
    disp = self.is_cooking ? '調理あり' : '調理なし(提供のみ)'
    return disp
  end

  # グループidで検索するスコープ
  scope :groups, -> (group_ids) {where( group_id: group_ids )}
  # 調理ありを検索するスコープ
  scope :cooking, -> {where( is_cooking: 'true' )}
  # 調理なしを検索するスコープ
  scope :non_cooking, -> {where( is_cooking: 'false' )}

end
