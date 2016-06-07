class WelcomeController < GroupBase

  authorize_resource :class => false # for cancancan

  def index
    # UserDetail.find( id )だと存在しな時にエラー吐く. nilを渡すようにする
    @user_detail = UserDetail.find_by(user_id: current_user.id)

    if @user_detail.nil? # ユーザ情報登録前
      @name = current_user.email
      render 'regist_user_detail' # viewをviews/welcome/regist_user_detailに
      # renderで指定したviewはindexメソッドの終了時に, デフォルトに代わって描写される.
    else
      @name = @user_detail.name_ja # そのうちlocaleで判断したい
    end

    # WelcomeIndexの各種項目を表示制御する
    # welcome_helper.rbで使用
    @config_panel = ConfigUserPermission.all.sort

    # Userが保有するグループ数
    @group_count = Group.where(user_id: current_user.id).count

  end

  def regist_user_detail
  end
end
