module WelcomeHelper

  # 表示するパネルの判定
  def show_enable_panel(panel, num_nosubrep_groups)
    # 参加団体，副代表以外は副代表が未登録の団体があれば表示しない
    if panel.id > 2 && num_nosubrep_groups > 0
      return
    end

    if panel.enable_show
      render partial: "#{panel.panel_partial}"
    end
  end
end
