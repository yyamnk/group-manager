ActiveAdmin.register ConfigUserPermission do

  permit_params :is_accepting, :is_only_show

  index do
      panel "注意書き" do
        "'非表示' 状態  : 両方を'いいえ'に変更. 対応するTop Pageの登録フォームを非表示. ユーザからの編集不可. "
      end

      id_column
      column :form_name
      column :is_accepting
      column :is_only_show
      column :panel_partial
      actions
  end

end
