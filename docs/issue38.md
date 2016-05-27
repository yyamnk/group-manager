# [機能追加] 参加団体フォーム受付の制御 #38

[優先度:高]
参加団体募集フォームの募集状態を制御するための機能追加. 
募集時期に応じて, 入力/閲覧できる情報を制約する. 

1. cancancanのabilityを書き換える
2. 募集に必要なviewを書き換える

[受付中], [閲覧可], [使用不可]の3状態を作る.

```
welcome/indexのカテゴリ単位で, 関連するmodel/viewをまとめて制御する
```

[issue #38](https://github.com/NUTFes/group-manager/issues/38)


# 実装の方針


DB上で3状態をつぎのように表現する．

* [受付中]: `(is_accepting, is_only_show) = (true, false)`
* [閲覧可]: `(is_accepting, is_only_show) = (false, true)`
* [使用不可]: `(is_accepting, is_only_show) = (false, false)`


# モデル生成

```
bundle exec rails g model ConfigUserPermission form_name:string is_accepting:boolean is_only_show:boolean
```

```
      t.string :form_name, null: false
      t.boolean :is_accepting, default: false
      t.boolean :is_only_show, default: false
```

```sh
$ rake db:migrate
== 20160527094623 CreateConfigUserPermissions: migrating ======================
-- create_table(:config_user_permissions)
   -> 0.0329s
== 20160527094623 CreateConfigUserPermissions: migrated (0.0330s) =============
```
