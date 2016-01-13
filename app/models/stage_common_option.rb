class StageCommonOption < ActiveRecord::Base
  belongs_to :group

  # 存在チェック
  validates :group_id, presence: true

  # 団体毎にユニーク
  validates :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content, :uniqueness => {:scope => [:group_id] }

end
