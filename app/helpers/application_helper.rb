module ApplicationHelper

  def show_edit_botton(path, record)
    # editが許可された場合のみEditボタンを表示する
    if @ability.can?(:update, record)
      return link_to t('.edit', :default => t("helpers.links.edit")),
        path,
        :class => 'btn btn-default btn-xs'
    end
  end

  def show_destroy_botton(path, record)
    # destroyが許可された場合のみEditボタンを表示する
    if @ability.can?(:destroy, record)
      return link_to t('.destroy', :default => t("helpers.links.destroy")),
        path,
        :method => :delete,
        :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
        :class => 'btn btn-xs btn-danger'
    end
  end
end
