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

## Dashboardに電力申請用のリンクを追加する

welcome_inedxに追加

## bootstrapを適用

```
bundle exec rails g bootstrap:themed powerOrders
    conflict  app/views/power_orders/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/power_orders/index.html.erb? (enter "h" for help) [Ynaqdh]
       force  app/views/power_orders/index.html.erb
    conflict  app/views/power_orders/new.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/power_orders/new.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/power_orders/new.html.erb
    conflict  app/views/power_orders/edit.html.erb
       force  app/views/power_orders/edit.html.erb
    conflict  app/views/power_orders/_form.html.erb
       force  app/views/power_orders/_form.html.erb
    conflict  app/views/power_orders/show.html.erb
       force  app/views/power_orders/show.html.erb
```

## power_orders/index 修正

カラム名用の辞書ファイルを追加
idカラムを削除
group_idからgroup_nameに修正

## モデルにバリデーション追加

条件，合計1000W以下，ついては後ほど追加する

## _formを修正

group選択を所有する団体のみで絞り込が必要
-> controllersにget_groupsで@groupsインスタンス変数を用意した

## showの修正

辞書参照先変更，辞書の追加

## indexで表示を絞込
## 1団体で合計1000Wを超える場合に追加を禁止する

[参考](http://qiita.com/n-oshiro/items/4a3188be66dd0e18bae5)
[参考](http://guides.rubyonrails.org/active_record_validations.html#working-with-validation-errors-errors)

`app/validators/power_order_validator.rb`にバリデートを追加
新規追加と更新で別のメソッドを指定できなかったので別クラスとした...

## _formを修正

バリデートでエラーを履いたときに，団体の選択を維持するように変更．
ヒントを追加




---

# ステージ企画専用のアンケート

## モデル

```
# ステージの場所
bundle exec rails g model stage name_ja:string name_en:string is_sunny:boolean
      invoke  active_record
      create    db/migrate/20150607101623_create_stages.rb
      create    app/models/stage.rb
rake db:migrate
== 20150607101623 CreateStages: migrating =====================================
-- create_table(:stages)
   -> 0.0140s
== 20150607101623 CreateStages: migrated (0.0141s) ============================
```

初期データ投入

```
rake db:seed_fu

== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/stage.rb
 - Stage {:id=>1, :name_ja=>"メインステージ", :is_sunny=>true}
 - Stage {:id=>2, :name_ja=>"サブステージ", :is_sunny=>true}
 - Stage {:id=>3, :name_ja=>"体育館", :is_sunny=>true}
 - Stage {:id=>4, :name_ja=>"マルチメディアセンター", :is_sunny=>true}
 - Stage {:id=>5, :name_ja=>"体育館", :is_sunny=>false}
 - Stage {:id=>6, :name_ja=>"マルチメディアセンター", :is_sunny=>false}
 - Stage {:id=>7, :name_ja=>"武道館", :is_sunny=>false}
```

```
# 開催する日付のモデル
bundle exec rails g model fesDate days_num:integer date:string
      invoke  active_record
      create    db/migrate/20150607105823_create_fes_dates.rb
      create    app/models/fes_date.rb

rake db:migrate
== 20150607105823 CreateFesDates: migrating ===================================
-- create_table(:fes_dates)
   -> 0.0062s
== 20150607105823 CreateFesDates: migrated (0.0063s) ==========================

# 初期データ投入
rake db:seed_fu
== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/fes_date.rb
 - FesDate {:id=>1, :days_num=>0, :date=>"準備日"}
 - FesDate {:id=>2, :days_num=>1, :date=>"1日目"}
 - FesDate {:id=>3, :days_num=>2, :date=>"2日目"}
```


## ステージ用の申請CURDを作成

```
bundle exec rails g scaffold stage_order group:references is_sunny:boolean fes_date:references stage_first:integer stage_second:integer time:string own_equipment:boolean bgm:boolean camera_permittion:boolean loud_sound:boolean

rake db:migrate
== 20150607110533 CreateStageOrders: migrating ================================
-- create_table(:stage_orders)
   -> 0.0163s
== 20150607110533 CreateStageOrders: migrated (0.0163s) =======================
```


## bootstrap適用

```
% bundle exec rails g bootstrap:themed StageOrders
    conflict  app/views/stage_orders/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/stage_orders/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/stage_orders/index.html.erb
    conflict  app/views/stage_orders/new.html.erb
       force  app/views/stage_orders/new.html.erb
    conflict  app/views/stage_orders/edit.html.erb
       force  app/views/stage_orders/edit.html.erb
    conflict  app/views/stage_orders/_form.html.erb
       force  app/views/stage_orders/_form.html.erb
    conflict  app/views/stage_orders/show.html.erb
       force  app/views/stage_orders/show.html.erb
```

index から団体名，天候，日付以外のカラムを削除

## 初期データの生成

ステージ企画の団体は，[1日目と2日目] × [晴れと雨] で4パターンの申請が必須．

モデルにバリデートを追加
stage_orderのレコードを生成するメソッドを追加
全てのグループで初期データを生成するタスクを追加

```
bundle exec rails g task stage_orders
      create  lib/tasks/stage_orders.rake
# 実行
rake stage_orders:generate_for_preexist
```

## formを修正

辞書を追加，いくつかのパラメータをhiddenに

## showを修正

StageOrder.kibou1, StageOrder.kibou2を追加

## indexを修正

辞書追加, 希望場所を表示

## ActiveAdminの管理対象に追加

```
bundle exec rails generate active_admin:resource StageOrder
```

---

# 電力申請の権限を追加

---

# 実施場所の申請

## モデル作成

```
bundle exec rails g model place name_ja:string name_en:string is_outside:boolean
      invoke  active_record
      create    db/migrate/20150607150120_create_places.rb
      create    app/models/place.rb

rake db:migrate
== 20150607150120 CreatePlaces: migrating =====================================
-- create_table(:places)
   -> 0.0051s
== 20150607150120 CreatePlaces: migrated (0.0052s) ============================

rake db:seed_fu
== Seed from /Volumes/Data/Dropbox/nfes15/group_manager/db/fixtures/place.rb
 - Place {:id=>1, :name_ja=>"事務棟エリア", :is_outside=>true}
 - Place {:id=>2, :name_ja=>"図書館エリア", :is_outside=>true}
 - Place {:id=>3, :name_ja=>"福利棟エリア", :is_outside=>true}
 - Place {:id=>4, :name_ja=>"ステージエリア", :is_outside=>true}
 - Place {:id=>5, :name_ja=>"体育館エリア", :is_outside=>true}
 - Place {:id=>6, :name_ja=>"セコムホール", :is_outside=>false}
 - Place {:id=>7, :name_ja=>"電気棟204", :is_outside=>false}
 - Place {:id=>8, :name_ja=>"電気棟206", :is_outside=>false}
 - Place {:id=>9, :name_ja=>"電気棟208", :is_outside=>false}
 - Place {:id=>10, :name_ja=>"電気棟212", :is_outside=>false}
 - Place {:id=>11, :name_ja=>"電気棟310", :is_outside=>false}
```

## 場所申請用のCURD生成

```
bundle exec rails g scaffold place_order group:references first:integer second:integer third:integer
      invoke  active_record
      create    db/migrate/20150607152236_create_place_orders.rb
      create    app/models/place_order.rb
      invoke  resource_route
       route    resources :place_orders
      invoke  scaffold_controller
      create    app/controllers/place_orders_controller.rb
      invoke    erb
      create      app/views/place_orders
      create      app/views/place_orders/index.html.erb
      create      app/views/place_orders/edit.html.erb
      create      app/views/place_orders/show.html.erb
      create      app/views/place_orders/new.html.erb
      create      app/views/place_orders/_form.html.erb
      invoke    helper
      create      app/helpers/place_orders_helper.rb
      invoke    jbuilder
      create      app/views/place_orders/index.json.jbuilder
      create      app/views/place_orders/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/place_orders.coffee
      invoke    scss
      create      app/assets/stylesheets/place_orders.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss

rake db:migrate
== 20150607152236 CreatePlaceOrders: migrating ================================
-- create_table(:place_orders)
   -> 0.0140s
== 20150607152236 CreatePlaceOrders: migrated (0.0141s) =======================
```

## bootstrap適用

```
# 一度views/place_orders/を全部消した...
bundle exec rails g bootstrap:themed PlaceOrders
      create  app/views/place_orders/index.html.erb
      create  app/views/place_orders/new.html.erb
      create  app/views/place_orders/edit.html.erb
      create  app/views/place_orders/_form.html.erb
      create  app/views/place_orders/show.html.erb
```

## 初期データの生成

Groupモデルにinit_place_orderメソッドを追加

```
bundle exec rails g task place_order
      create  lib/tasks/place_order.rake
# 中身を書いて実行
rake place_order:generate_for_preexist
```

## Group作成時にPlaceOrderの初期データを投入させる

## welcome_inedxにリンクを追加

## formを修正

## PlaceOrderにバリデート追加

## show, index修正

## ActiveAdminに追加

```
bundle exec rails generate active_admin:resource PlaceOrder
      create  app/admin/place_order.rb
```

## 権限を追加

## タスク実行

```
rake place_order:generate_for_preexist
```

で初期データを生成 -> 更新 -> 再度タスク実行で別のレコードができる．
group_idでユニークにしないとダメ．
