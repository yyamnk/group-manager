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
