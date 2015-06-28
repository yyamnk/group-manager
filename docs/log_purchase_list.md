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
