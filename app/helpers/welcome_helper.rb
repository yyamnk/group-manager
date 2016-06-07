module WelcomeHelper

  # 表示するパネルの判定
  def show_enable_panel(panel, num_nosubrep_groups, group_count)

    # ユーザが参加団体を登録していない場合, 
    # 参加団体を表示
    return  if panel.id > 1 && group_count == 0

    # もしくは副代表が未登録の場合,
    # 参加団体と副代表を表示
    return  if panel.id > 2 && num_nosubrep_groups > 0 


    # 閲覧, 編集可の場合のみ, 項目を表示する
    if panel.is_accepting || panel.is_only_show
      render partial: "#{panel.panel_partial}"
    end
  end
end
