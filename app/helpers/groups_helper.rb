module GroupsHelper

  def show_new_group()
    # createが許可された場合のみNewボタンを表示する
    if @ability.can?(:create, Group.new(user_id: current_user.id))
      return link_to t('.new', :default => t("helpers.links.new")),
        new_group_path,
        :class => 'btn btn-primary'
    end
  end

end
