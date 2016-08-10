# issue 143 実装ログ

[貸出物品割当入力機能](https://github.com/NUTFes/group-manager/issues/143)  

作業中は, 必ず細かくgit commitしておくこと.  
特に, ``rails g`` や``rake``コマンドの後は大きな変更が加えられるので,   
その時点の状態を保存しておく.   


## CRUDの実装 (MVCの生成)

```sh
$ bundle exec rails g scaffold AssignRentalItem rental_order:references rentable_item:references num:integer
Running via Spring preloader in process 25078
      invoke  active_record
      create    db/migrate/20160810072112_create_assign_rental_items.rb
      create    app/models/assign_rental_item.rb
      invoke  resource_route
       route    resources :assign_rental_items
      invoke  scaffold_controller
      create    app/controllers/assign_rental_items_controller.rb
      invoke    erb
      create      app/views/assign_rental_items
      create      app/views/assign_rental_items/index.html.erb
      create      app/views/assign_rental_items/edit.html.erb
      create      app/views/assign_rental_items/show.html.erb
      create      app/views/assign_rental_items/new.html.erb
      create      app/views/assign_rental_items/_form.html.erb
      invoke    helper
      create      app/helpers/assign_rental_items_helper.rb
      invoke    jbuilder
      create      app/views/assign_rental_items/index.json.jbuilder
      create      app/views/assign_rental_items/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/assign_rental_items.coffee
      invoke    scss
      create      app/assets/stylesheets/assign_rental_items.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
```


## マイグレーションファイルの変更 + 実行

テーブルの各カラム`rental_order`, `rentable_item`, `num`は必須．
なので，DBレベルで制約を追加する．

```diff
--- a/db/migrate/20160810072112_create_assign_rental_items.rb
+++ b/db/migrate/20160810072112_create_assign_rental_items.rb
@@ -1,8 +1,8 @@
 class CreateAssignRentalItems < ActiveRecord::Migration
   def change
     create_table :assign_rental_items do |t|
-      t.references :rental_order, index: true, foreign_key: true
-      t.references :rentable_item, index: true, foreign_key: true
+      t.references :rental_order, index: true, foreign_key: true, null: false
+      t.references :rentable_item, index: true, foreign_key: true, null: false
       t.integer :num

       t.timestamps null: false
```

マイグレーション実行

```sh
$ rake db:migrate
== 20160810072112 CreateAssignRentalItems: migrating ==========================
-- create_table(:assign_rental_items)
   -> 0.0411s
== 20160810072112 CreateAssignRentalItems: migrated (0.0411s) =================
```
