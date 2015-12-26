class GroupBase < ApplicationController

  def get_groups
    # 登録時の選択肢に使うグループを取得
    # 自分の所有するグループ, 副代表登録済み,
    @groups = Group.get_has_subreps(current_user.id)
  end
end
