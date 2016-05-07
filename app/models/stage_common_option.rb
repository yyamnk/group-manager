class StageCommonOption < ActiveRecord::Base
  belongs_to :group

  # 存在チェック
  validates :group_id, :stage_content, presence: true
  validates :own_equipment, :bgm, :camera_permittion, :loud_sound, inclusion: {in: [true, false]}

end
