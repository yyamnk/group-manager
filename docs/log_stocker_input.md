<!-- ************** docs/log_stocker_input.md **************
Created    : 2016-Jan-15
Last Change: 2016-Mar-29.
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

# StockedItems(在庫テーブル )のCURD追加

```sh
$ bundle exec rails g scaffold StockerItem rental_item:references stocker_place:references num:integer
      invoke  active_record
      create    db/migrate/20160114162056_create_stocker_items.rb
      create    app/models/stocker_item.rb
      invoke  resource_route
       route    resources :stocker_items
      invoke  scaffold_controller
      create    app/controllers/stocker_items_controller.rb
      invoke    erb
      create      app/views/stocker_items
      create      app/views/stocker_items/index.html.erb
      create      app/views/stocker_items/edit.html.erb
      create      app/views/stocker_items/show.html.erb
      create      app/views/stocker_items/new.html.erb
      create      app/views/stocker_items/_form.html.erb
      invoke    helper
      create      app/helpers/stocker_items_helper.rb
      invoke    jbuilder
      create      app/views/stocker_items/index.json.jbuilder
      create      app/views/stocker_items/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/stocker_items.coffee
      invoke    scss
      create      app/assets/stylesheets/stocker_items.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
```

マイグレーションファイル編集

```sh
@@ -3,7 +3,7 @@ class CreateStockerItems < ActiveRecord::Migration
     create_table :stocker_items do |t|
       t.references :rental_item, index: true, foreign_key: true
       t.references :stocker_place, index: true, foreign_key: true
-      t.integer :num
+      t.integer :num, null: false
```

マイグレート

```sh
$ rake db:migrate
== 20160114162056 CreateStockerItems: migrating ===============================
-- create_table(:stocker_items)
   -> 0.0379s
== 20160114162056 CreateStockerItems: migrated (0.0379s) ======================
```

バリデーション追加

```diff
 class StockerItem < ActiveRecord::Base
   belongs_to :rental_item
   belongs_to :stocker_place
+
+  validates :rental_item_id, :stocker_place_id, :num, presence: true
+  validates :num, numericality: {
+    only_integer: true,
+    greater_than_or_equal_to: 0
+  }
```

bootstrapテーマ適用

```sh
$ bundle exec rails g bootstrap:themed StockerItems
    conflict  app/views/stocker_items/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/stocker_items/index.html.erb? (enter "h" for help) [Ynaqdh] Y
       force  app/views/stocker_items/index.html.erb
    conflict  app/views/stocker_items/new.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/stocker_items/new.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/stocker_items/new.html.erb
    conflict  app/views/stocker_items/edit.html.erb
       force  app/views/stocker_items/edit.html.erb
    conflict  app/views/stocker_items/_form.html.erb
       force  app/views/stocker_items/_form.html.erb
    conflict  app/views/stocker_items/show.html.erb
       force  app/views/stocker_items/show.html.erb
```

管理者・運営者のみが触るフォームを予定している．
index, _formのみ最低限の変更 + 辞書を追加

`<%= stocker_item.stocker_place %>`でStocker.nameを表示させるため
`StockerPlace.to_s`を追加．


# StockerPlaces修正

貸出場所の多くは準備日にも利用可能と考える．
`is_available_fesdate`のフォルト値を変更

```
$ bundle exec rails g migration ChangeColumnToStockerPlaces
$ vim db/migrate/20160114154302_create_stocker_places.rb
# 編集
$ rake db:migrate
```
