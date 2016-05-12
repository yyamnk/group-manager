class Place < ActiveRecord::Base
  has_many :place_allow_lists


  def to_s # aciveAdmin, simple_formで表示名を指定する
    if self.is_outside
      self.name_ja
    else
      self.name_ja + " (屋内)"
    end
  end

  # 選択肢の生成用，団体idで選択可能な場所を返す
  def self.collections(group_id)
    group_category_id = Group.find(group_id).group_category_id
    # 模擬店は外
    if [1, 2].include? group_category_id
      self.where( is_outside: true )
    elsif [4, 5].include? group_category_id
    # 展示・体験, その他は屋外 or 屋内
      self.all
    end
  end

  #
end
