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


## 既存のモデルへRailsレベルで関連付け

マイグレーションにより，DBレベルで
AssignRentalItemテーブルとRentalOrder, RentableItemは関連付けされている．

この関連付けは`../app/models/assign_rental_item.rb`には書かれているが，
`../app/models/rental_order.rb`, `../app/models/rental_item.rb`には
入っていない．
ので追加する．

```diff
 class RentalOrder < ActiveRecord::Base
   belongs_to :group
   belongs_to :rental_item
+  has_many :assign_rental_item

   validates :group_id, :rental_item_id, :num, presence: true
```

```diff
 class RentableItem < ActiveRecord::Base
   belongs_to :stocker_item
   belongs_to :stocker_place
+  has_many :assign_rental_item

   validates :stocker_item_id, :stocker_place_id, :max_num, presence: true
```


## バリデーションを追加

モデルにnull値を防止するバリデーションを追加する

```diff
 class AssignRentalItem < ActiveRecord::Base
   belongs_to :rental_order
   belongs_to :rentable_item
+
+  validates_presence_of :rental_order_id, :rentable_item_id, :num
+  validates :num, numericality: :only_integer
+  validates :rental_order_id, uniqueness: {scope: [:rentable_item_id] }
 end
```


## bootstrapを適用

```sh
$ bundle exec rails g bootstrap:themed AssignRentalItems
Running via Spring preloader in process 39834
    conflict  app/views/assign_rental_items/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/assign_rental_items/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/assign_rental_items/index.html.erb
    conflict  app/views/assign_rental_items/new.html.erb
       force  app/views/assign_rental_items/new.html.erb
    conflict  app/views/assign_rental_items/edit.html.erb
       force  app/views/assign_rental_items/edit.html.erb
    conflict  app/views/assign_rental_items/_form.html.erb
       force  app/views/assign_rental_items/_form.html.erb
    conflict  app/views/assign_rental_items/show.html.erb
       force  app/views/assign_rental_items/show.html.erb
```