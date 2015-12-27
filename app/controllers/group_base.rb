class GroupBase < ApplicationController

  before_action :set_groups # カレントユーザの所有する団体を@groupsへ

  def set_groups
    # ログインしていなければ何もしない
    return if current_user.nil?
    # 今年のレコード
    this_year = FesYear.where(fes_year: Time.now.year)
    # 自分の所有するグループで今年に紐づくもの
    @groups = Group.where(user_id: current_user.id).
                    where(fes_year: this_year)
    # ログインユーザの所有しているグループのうち，
    # 副代表が登録されていない団体数を取得する
    @num_nosubrep_groups = @groups.count -
                           Group.get_has_subreps(current_user.id).count
  end

end
