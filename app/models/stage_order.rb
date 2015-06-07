class StageOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :fes_date

  validates :group_id, :fes_date_id, :time, presence: true
  validates :group_id, :uniqueness => {:scope => [:fes_date_id, :is_sunny] } # 日付と天候でユニーク
  validate :select_different_stage

  def tenki
    return is_sunny ? "晴天時" :  "雨天時"
  end

  def date
    return FesDate.find(fes_date_id).date
  end

  def select_different_stage
    return if stage_first.nil? & stage_second.nil?
    if stage_first == stage_second
        errors.add( :stage_first, "候補が重複しています。")
        errors.add( :stage_second, "候補が重複しています。")
    end
  end
end
