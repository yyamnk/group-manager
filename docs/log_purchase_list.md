# 購入物品の登録処理 実装ログ

## 基本方針

生鮮品(1日目で使用), 生鮮品(2日目で使用), 非生鮮品(1日目・2日目共通)の品目と購入先の登録が必要．
生鮮品は当日しか購入できない．

関連するモデル

* Shopモデル
    * 販売店舗を記録している
        * 名称，tel，営業時間等
* FoodProductモデル
    * 販売する品目を記録している．
* PurchaseListモデル (今回追加する)
    * 購入物品を記録する
    * カラム
        * 提供品目 FoodProductモデルに関連付け
        * 購入先 Shopモデルに関連付け
        * 購入する品目の種類(生鮮 or それ以外): boolean
        * 購入する材料名: string
        * 購入日 FesDateに関連付け

formは2段階にしたくないので，formへのリンクでGETパラメータを渡すことにする．

welcome/indexからの遷移先は，「生鮮品」「非生鮮品」「非調理品」の3つにする．


## scaffold でCURD生成

```
bundle exec rails g scaffold purchaseList food_product:references shop:references fes_date:references is_fresh:boolean
      invoke  active_record
      create    db/migrate/20150628192734_create_purchase_lists.rb
      create    app/models/purchase_list.rb
      invoke  resource_route
       route    resources :purchase_lists
      invoke  scaffold_controller
      create    app/controllers/purchase_lists_controller.rb
      invoke    erb
      create      app/views/purchase_lists
      create      app/views/purchase_lists/index.html.erb
      create      app/views/purchase_lists/edit.html.erb
      create      app/views/purchase_lists/show.html.erb
      create      app/views/purchase_lists/new.html.erb
      create      app/views/purchase_lists/_form.html.erb
      invoke    helper
      create      app/helpers/purchase_lists_helper.rb
      invoke    jbuilder
      create      app/views/purchase_lists/index.json.jbuilder
      create      app/views/purchase_lists/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/purchase_lists.coffee
      invoke    scss
      create      app/assets/stylesheets/purchase_lists.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
```


## マイグレーションの編集, 実行

`food_product`, `shop`, `fes_date`に`null: false`を指定

```
rake db:migrate

== 20150628192734 CreatePurchaseLists: migrating ==============================
-- create_table(:purchase_lists)
   -> 0.0165s
== 20150628192734 CreatePurchaseLists: migrated (0.0166s) =====================
```

## indexメソッドのリネーム( index -> index_fresh )，ルーティング・テンプレートの設定

対象とするレコードに応じて3つのindexページを作る．
最初は生鮮品の表示をするindex_freshとする．

```
# app/controllers/purchase_lists_controller.rb

   # GET /purchase_lists
   # GET /purchase_lists.json
-  def index
+  def index_fresh
     @purchase_lists = PurchaseList.all
```   

メソッド名を書き換えたので，このメソッドに対応するルーティングを設定

```
Rails.application.routes.draw do
-  resources :purchase_lists
+  resources :purchase_lists do
+    # 標準の7つ以外を追加する
+    collection do
+      get 'index_fresh'
+    end
+  end
   resources :shops
   resources :food_products
```

welcomeページに生鮮品用のリンクを追加

```
# app/views/welcome/index.html.erb
             :class => 'btn btn-default' %>
   </div>
 </div>
+
+<div class="panel panel-primary">
+  <div class="panel-heading">
+    <h3 class="panel-title">販売食品の商品・材料の登録</h3>
+  </div>
+  <div class="panel-body">
+    模擬店で販売する食品の商品(提供の場合)，材料(調理品の場合)の購入先を登録して下さい。<br>
+    対象: 参加形式が「模擬店(食品販売)」の団体<br>
+    <%= link_to t('調理品の材料(生鮮食品)の一覧'),
+            index_fresh_purchase_lists_path,
+            :class => 'btn btn-default' %>
+  </div>
+</div>
```

viewファイルをコピー

```
cp app/views/purchase_lists/index.html.erb app/views/purchase_lists/index_fresh.html.erb
```

## bootstrap適用

```
bundle exec rails g bootstrap:themed PurchaseLists
    conflict  app/views/purchase_lists/index.html.erb
Overwrite /Volumes/HD2/Dropbox/nfes15/group_manager/app/views/purchase_lists/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/purchase_lists/index.html.erb
    conflict  app/views/purchase_lists/new.html.erb
       force  app/views/purchase_lists/new.html.erb
    conflict  app/views/purchase_lists/edit.html.erb
       force  app/views/purchase_lists/edit.html.erb
    conflict  app/views/purchase_lists/_form.html.erb
       force  app/views/purchase_lists/_form.html.erb
    conflict  app/views/purchase_lists/show.html.erb
       force  app/views/purchase_lists/show.html.erb
```

`app/views/purchase_lists/index_fresh.html.erb`には適用されなかった．
改変されたindexを再度コピーする．

```
cp app/views/purchase_lists/index.html.erb app/views/purchase_lists/index_fresh.html.erb
```

## itemsカラムを追加

`PurchaseList`に購入品目のカラムが無かった．追加する．

```
bundle exec rails g migration AddColumnToPurchaseList items:string
      invoke  active_record
      create    db/migrate/20150628202115_add_column_to_purchase_list.rb
```

マイグレーションファイルを編集して`null: false`を設定

```
rake db:migrate

== 20150628202115 AddColumnToPurchaseList: migrating ==========================
-- add_column(:purchase_lists, :items, :string, {:null=>false})
   -> 0.0024s
== 20150628202115 AddColumnToPurchaseList: migrated (0.0025s) =================
```

## views/index_freshの編集

カラムの整理と関連する辞書を追加

## models/purchase_listにバリデーションを追加

```
+  validates_presence_of :food_product_id, :shop_id, :fes_date_id, :items
```

## views/_formの編集

登録フォームは2枚(調理有りのFoodProduct用，調理無し用)作成する．
`is_fresh`, `fes_date_id`はhiddenで送る．

現状確認のために`_form`を編集
`FesDate`に`to_s`メソッド追加
`permit_params`に追加した`:items`が入ってなかった．コントローラで追加


## views/index_fresh -> new_freshメソッド -> views/new_fresh の流れを実装

コントローラで`new`を生鮮食品用のメソッドへ変更

```
# app/controllers/purchase_lists_controller.rb
@@ -13,8 +13,8 @@ class PurchaseListsController < ApplicationController
   end

   # GET /purchase_lists/new
-  def new
-    @purchase_list = PurchaseList.new
+  def new_fresh
+    @purchase_list = PurchaseList.new( is_fresh: params[:is_fresh], fes_date_id: params[:fes_date_id])
   end
```

`views/index_fresh`に1日目の生鮮食品，2日目の生鮮食品のボタンを追加．getパラメータを付加．

```
# app/views/purchase_lists/index_fresh.html.erb

-<%= link_to t('.new', :default => t("helpers.links.new")),
-            new_purchase_list_path,
-            :class => 'btn btn-primary' %>
+<%= link_to '1日目で使用する生鮮食品を追加',
+            new_fresh_purchase_lists_path(is_fresh: true, fes_date_id: 2), # 生鮮食品1日目
+            :class => 'btn btn-primary'%>
+
+<%= link_to '2日目で使用する生鮮食品を追加',
+            new_fresh_purchase_lists_path(is_fresh: true, fes_date_id: 3), # 生鮮食品2日目
+            :class => 'btn btn-primary'%>
```

ルーティングを設定
 
```
# config/routes.rb

     # 標準の7つ以外を追加する
     collection do
       get 'index_fresh'
+      get 'new_fresh'
     end
```

viewのnewをリネーム

```
cp app/views/purchase_lists/new.html.erb app/views/purchase_lists/new_fresh.html.erb
```

formでパラメータをhiddenに

```
# app/views/purchase_lists/_form.html.erb

@@ -6,15 +6,12 @@
   <%= f.association :shop %>
   <%= error_span(@purchase_list[:shop_id]) %>

-  <%= f.association :fes_date %>
-  <%= error_span(@purchase_list[:fes_date_id]) %>
-
-  <%= f.input :is_fresh %>
-  <%= error_span(@purchase_list[:is_fresh]) %>
-
   <%= f.input :items %>
   <%= error_span(@purchase_list[:items]) %>

+  <%= f.hidden_field :fes_date_id, value: @purchase_list.fes_date_id %>
+  <%= f.hidden_field :is_fresh, value: @purchase_list.is_fresh %>
```

## controllers/PurchaseList#index_freshの変更

`PurchaseListsController#get_foo_products`で
ユーザが所有する模擬店(食品販売)のグループに登録された販売食品のidを`@food_product_ids`に取得．

`PurchaseListsController#index_fresh`で生鮮品のみに絞り込み

```
--- a/app/controllers/purchase_lists_controller.rb
+++ b/app/controllers/purchase_lists_controller.rb
@@ -1,10 +1,11 @@
 class PurchaseListsController < ApplicationController
   before_action :set_purchase_list, only: [:show, :edit, :update, :destroy]
+  before_action :get_food_products # 各アクション実行前に実行

   # GET /purchase_lists
   # GET /purchase_lists.json
   def index_fresh
-    @purchase_lists = PurchaseList.all
+    @purchase_lists = PurchaseList.where( food_product_id: @food_product_ids ).where( is_fresh: 'true')
   end

   # GET /purchase_lists/1
@@ -71,4 +72,12 @@ class PurchaseListsController < ApplicationController
     def purchase_list_params
       params.require(:purchase_list).permit(:food_product_id, :shop_id, :fes_date_id, :is_fresh, :items)
     end
+
+    def get_food_products
+      # ユーザが所有し，種別が模擬店(食品販売)の団体のid
+      group_ids = Group.where( "user_id = ? and group_category_id = ?", current_user.id, 1).pluck('id')
+      # logger.debug group_ids
+      @food_product_ids = FoodProduct.where( group_id: group_ids).pluck('id')
+      # logger.debug @food_product_ids
+    end
```

## new_fresh -> views/new(_form)で選択可能な販売食品を絞り込み

絞り込む要素は
1. 所有グループに紐付いた
2. 調理ありの
販売食品なので，`app/models/food_product.rb`にスコープ`gorups`, `cooking`を追加して

```
# contorllerで@gorup_idsを設定
@group_ids = Group.where( "user_id = ? and group_category_id = ?", current_user.id, 1).pluck('id')

# viewsで該当するようにスコープを連結
FoodProduct.groups(@group_ids).cooking 
```

で取得させる．

## new_fresh -> views/new(_form)で選択可能な仕入先を絞り込み

`Shop.closed`の配列を検索するのが面倒．

`is_closed_sun:boolean`, `is_closed_sat:boolean`で対応することにする．

### マイグレーションで`closed`カラムを削除, `is_closed_曜日`カラムを追加

```
bundle exec rails g migration RemoveColumnToShop closed

      invoke  active_record
      create    db/migrate/20150629090720_remove_column_to_shop.rb

bundle exec rails g migration AddClosedColumnToShop is_closed_sun:boolean is_closed_mon:boolean is_closed_tue:boolean is_closed_wed:boolean is_closed_thu:boolean is_closed_fri:boolean is_closed_sat:boolean is_closed_holiday:boolean 

      invoke  active_record
      create    db/migrate/20150629091153_add_closed_column_to_shop.rb

rake db:migrate

== 20150629090720 RemoveColumnToShop: migrating ===============================
-- remove_column(:shops, :closed, :string)
   -> 0.0020s
== 20150629090720 RemoveColumnToShop: migrated (0.0023s) ======================

== 20150629091153 AddClosedColumnToShop: migrating ============================
-- add_column(:shops, :is_closed_sun, :boolean)
   -> 0.0007s
-- add_column(:shops, :is_closed_mon, :boolean)
   -> 0.0004s
-- add_column(:shops, :is_closed_tue, :boolean)
   -> 0.0004s
-- add_column(:shops, :is_closed_wed, :boolean)
   -> 0.0003s
-- add_column(:shops, :is_closed_thu, :boolean)
   -> 0.0004s
-- add_column(:shops, :is_closed_fri, :boolean)
   -> 0.0003s
-- add_column(:shops, :is_closed_sat, :boolean)
   -> 0.0004s
-- add_column(:shops, :is_closed_holiday, :boolean)
   -> 0.0003s
== 20150629091153 AddClosedColumnToShop: migrated (0.0035s) ===================
```
