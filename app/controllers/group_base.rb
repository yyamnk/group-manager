class GroupBase < ApplicationController

  before_action :set_groups # カレントユーザの所有する団体を@groupsへ

  def set_groups
    # ログインしていなければ何もしない
    return if current_user.nil?
    # 登録時の選択肢に使うグループを取得
    # 自分の所有するグループ, 副代表登録済み,
    @groups = Group.where(user_id: current_user.id)
    # ログインユーザの所有しているグループのうち，
    # 副代表が登録されていない団体数を取得する
    @num_nosubrep_groups = @groups.count -
                           Group.get_has_subreps(current_user.id).count
  end

end
