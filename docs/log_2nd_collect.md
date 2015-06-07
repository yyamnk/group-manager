# 第二回募集にむけたアップデート

## 物品貸出の募集をする

モデル生成

```
# 貸出物品
bundle exec rails g model rentalItem name_ja:string name_en:string
      invoke  active_record
      create    db/migrate/20150605080243_create_rental_items.rb
      create    app/models/rental_item.rb

# 貸出物品が選択可能な団体のカテゴリ
bundle exec rails g model rentalItemAllowList rental_item:references group_category:references
      invoke  active_record
      create    db/migrate/20150605081834_create_rental_item_allow_lists.rb
      create    app/models/rental_item_allow_list.rb

# モデル初期データ投入
rake db:seed_fu

== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/rental_item.rb
 - RentalItem {:id=>1, :name_ja=>"机", :name_en=>"table"}
 - RentalItem {:id=>2, :name_ja=>"長机", :name_en=>"long table"}
 - RentalItem {:id=>3, :name_ja=>"椅子", :name_en=>"chair"}
 - RentalItem {:id=>4, :name_ja=>"パイプ椅子", :name_en=>"pipe chair"}
 - RentalItem {:id=>5, :name_ja=>"パーテーション", :name_en=>"partition"}
 - RentalItem {:id=>6, :name_ja=>"掲示板", :name_en=>"bulletin board"}
 - RentalItem {:id=>7, :name_ja=>"暗幕", :name_en=>"black curtain"}
 - RentalItem {:id=>8, :name_ja=>"マイク", :name_en=>"microphone"}

== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/rental_item_allow_list.rb
 - RentalItemAllowList {:id=>1, :rental_item_id=>1, :group_category_id=>1}
 - RentalItemAllowList {:id=>2, :rental_item_id=>1, :group_category_id=>2}
 - RentalItemAllowList {:id=>3, :rental_item_id=>1, :group_category_id=>4}
 - RentalItemAllowList {:id=>4, :rental_item_id=>1, :group_category_id=>5}
 - RentalItemAllowList {:id=>5, :rental_item_id=>2, :group_category_id=>1}
 - RentalItemAllowList {:id=>6, :rental_item_id=>2, :group_category_id=>2}
 - RentalItemAllowList {:id=>7, :rental_item_id=>2, :group_category_id=>4}
 - RentalItemAllowList {:id=>8, :rental_item_id=>2, :group_category_id=>5}
 - RentalItemAllowList {:id=>9, :rental_item_id=>3, :group_category_id=>1}
 - RentalItemAllowList {:id=>10, :rental_item_id=>3, :group_category_id=>2}
 - RentalItemAllowList {:id=>11, :rental_item_id=>3, :group_category_id=>3}
 - RentalItemAllowList {:id=>12, :rental_item_id=>3, :group_category_id=>4}
 - RentalItemAllowList {:id=>13, :rental_item_id=>3, :group_category_id=>5}
 - RentalItemAllowList {:id=>14, :rental_item_id=>4, :group_category_id=>1}
 - RentalItemAllowList {:id=>15, :rental_item_id=>4, :group_category_id=>2}
 - RentalItemAllowList {:id=>16, :rental_item_id=>4, :group_category_id=>3}
 - RentalItemAllowList {:id=>17, :rental_item_id=>4, :group_category_id=>4}
 - RentalItemAllowList {:id=>18, :rental_item_id=>4, :group_category_id=>5}
 - RentalItemAllowList {:id=>19, :rental_item_id=>5, :group_category_id=>1}
 - RentalItemAllowList {:id=>20, :rental_item_id=>5, :group_category_id=>2}
 - RentalItemAllowList {:id=>21, :rental_item_id=>5, :group_category_id=>3}
 - RentalItemAllowList {:id=>22, :rental_item_id=>5, :group_category_id=>4}
 - RentalItemAllowList {:id=>23, :rental_item_id=>5, :group_category_id=>5}
 - RentalItemAllowList {:id=>24, :rental_item_id=>6, :group_category_id=>1}
 - RentalItemAllowList {:id=>25, :rental_item_id=>6, :group_category_id=>2}
 - RentalItemAllowList {:id=>26, :rental_item_id=>6, :group_category_id=>4}
 - RentalItemAllowList {:id=>27, :rental_item_id=>6, :group_category_id=>5}
 - RentalItemAllowList {:id=>28, :rental_item_id=>7, :group_category_id=>1}
 - RentalItemAllowList {:id=>29, :rental_item_id=>7, :group_category_id=>2}
 - RentalItemAllowList {:id=>30, :rental_item_id=>7, :group_category_id=>4}
 - RentalItemAllowList {:id=>31, :rental_item_id=>7, :group_category_id=>5}
 - RentalItemAllowList {:id=>32, :rental_item_id=>8, :group_category_id=>3}
```

Scoffoldで貸出物品のCURDを生成

```
# 貸出物品の希望調査
bundle exec rails g scaffold rentalOrder group:references rental_item:references num:integer
rake db:migrate
```

物品貸出用のリンクをDashboardに追加．
app/views/welcome_inedxを修正．

RentalOrderにbootstrapを適用

```
bundle exec rails g bootstrap:themed RentalOrders
    conflict  app/views/rental_orders/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/rental_orders/index.html.erb? (enter "h" for help) [Ynaqdh] Y
       force  app/views/rental_orders/index.html.erb
    conflict  app/views/rental_orders/new.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/rental_orders/new.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/rental_orders/new.html.erb
    conflict  app/views/rental_orders/edit.html.erb
       force  app/views/rental_orders/edit.html.erb
    conflict  app/views/rental_orders/_form.html.erb
       force  app/views/rental_orders/_form.html.erb
    conflict  app/views/rental_orders/show.html.erb
       force  app/views/rental_orders/show.html.erb
```

rental_orders/indexを修正

各モデルにバリデーションを追加する


実装の方針:

ユーザは貸出物品の更新のみとする．
システムは予め各団体に関連した全ての貸出物品を数量0でレコードをつくる．

RentalOrderの初期レコードはGroupの作成，及びRentalItemの作成時に自動的に追加する必要がある．

Groupクラスにinit_rental_ordersメソッドを追加する
    メソッドの中身: 全てのRentalItemを数量0とするRentalOrderのレコードを作成．
    参加団体が作成されたら，Group.find(id).init_rental_ordersを実行．

RentalItemクラスにinit_rental_ordersメソッドを追加する
    メソッドの中身: 全ての参加団体に対応する数量0のRentalOrderレコードを作成．
    RentalItemが作成されたら，RentalItem.find(id).init_rental_ordersを実行．

今回は既に参加団体が作成されているので，Group.init_rental_ordersを手動で実行する．

参加団体作成時にGroup.init_rental_ordersメソッドを実行

rental_order/indexを修正．

"今回は既に参加団体が作成されているので，Group.init_rental_ordersを手動で実行する．"を実行するタスクを作成する

```
bundle exec rails g task rental_orders
      create  lib/tasks/rental_orders.rake
```

実行は`rake rental_orders:generate_for_preexist`で．
既存のレコードは上書きされない(ユニークでバリデートされるので)


## 貸出物品に関連するモデルをRailsAdminの管理対象に追加する

```
bundle exec rails generate active_admin:resource RentalItem
      create  app/admin/rental_item.rb
bundle exec rails generate active_admin:resource RentalOrder
      create  app/admin/rental_order.rb
bundle exec rails generate active_admin:resource RentalItemAllowList
      create  app/admin/rental_item_allow_list.rb
```

## herokuへupdate

```
git push heroku master
heroku run:detached rake db:migrate
heroku run:detached rake db:seed_fu
heroku run:detached rake rental_orders:generate_for_preexist
```

## フォーム，詳細表示を修正

`app/views/rental_orders/_form.html.erb' -> group_id, rental_item_idをhiddenへ
`app/views/rental_orders/show.html.erb' -> destroyのボタン削除

## RentalOrderに権限を追加

```
# app/controllers/rental_orders_controller.rb に追加
load_and_authorize_resource # for cancancan

# app/models/ability.rb に追加
    ...
      # 貸出物品は自分の団体のみ読み，更新を許可
      groups = Group.where( user_id: user.id ).pluck('id')
      can [:read, :update], RentalOrder, :group_id => groups
```

ここまで: 54ff23c


--- 

# 電力申請

## 電力申請用のCURDを生成

```
bundle exec rails g scaffold power_order group:references item:string power:integer
      invoke  active_record
      create    db/migrate/20150607054939_create_power_orders.rb
      create    app/models/power_order.rb
      invoke  resource_route
       route    resources :power_orders
      invoke  scaffold_controller
      create    app/controllers/power_orders_controller.rb
      invoke    erb
      create      app/views/power_orders
      create      app/views/power_orders/index.html.erb
      create      app/views/power_orders/edit.html.erb
      create      app/views/power_orders/show.html.erb
      create      app/views/power_orders/new.html.erb
      create      app/views/power_orders/_form.html.erb
      invoke    helper
      create      app/helpers/power_orders_helper.rb
      invoke    jbuilder
      create      app/views/power_orders/index.json.jbuilder
      create      app/views/power_orders/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/power_orders.coffee
      invoke    scss
      create      app/assets/stylesheets/power_orders.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
rake db:migrate
== 20150607054939 CreatePowerOrders: migrating ================================
-- create_table(:power_orders)
   -> 0.0112s
== 20150607054939 CreatePowerOrders: migrated (0.0113s) =======================
```


