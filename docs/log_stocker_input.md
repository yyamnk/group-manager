<!-- ************** docs/log_stocker_input.md **************
Created    : 2016-Jan-15
Last Change: 2016-Jan-15.
-->

[[機能追加] 全貸出物品の在庫情報 入力機能 #20](https://github.com/NUTFes/group-manager/issues/20)
の実装ログ

# StockerPlace テーブル作成

```sh
$ bundle exec rails g model StockerPlace name:string is_available_fesdate:boolean
      invoke  active_record
      create    db/migrate/20160114154302_create_stocker_places.rb
      create    app/models/stocker_place.rb
```

マイグレーションファイル編集

```diff
 class CreateStockerPlaces < ActiveRecord::Migration
   def change
     create_table :stocker_places do |t|
-      t.string :name
-      t.boolean :is_available_fesdate
+      t.string :name, null: false
+      t.boolean :is_available_fesdate, null: false, default: false

       t.timestamps null: false
     end
```

マイグレート

```sh
$ rake db:migrate
== 20160114154302 CreateStockerPlaces: migrating ==============================
-- create_table(:stocker_places)
   -> 0.0494s
== 20160114154302 CreateStockerPlaces: migrated (0.0494s) =====================
```

バリデーション追加

```diff
 class StockerPlace < ActiveRecord::Base
+  validates :name, :is_available_fesdate, presence: true
 end
```

seed追加して`rake db:seed_fu`


管理対象へ追加

```sh
$ bundle exec rails g active_admin:resource StockerPlace
      create  app/admin/stocker_place.rb
```

管理画面で編集可能にするためpermit_paramsを設定

```diff
@@ -14,5 +14,6 @@ ActiveAdmin.register StockerPlace do
   #   permitted
   # end

+  permit_params :list, :of, :attributes, :on, :model

 end
```
