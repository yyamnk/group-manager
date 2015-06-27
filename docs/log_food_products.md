# 販売食品の登録機能実装のログ

## 基本方針

* FoodProductモデル
    * group_id: 運営団体
    * name: プロダクト名称
    * num: 提供予定数量
    * is_cooking: 調理の有無

のCURDを実装する．

## scaffold

```
# curd生成
bundle exec rails g scaffold food_product group:references name:string num:integer is_cooking:boolean
```

`db/migrate/20150627091843_create_food_products.rb`で`null:false`を設定
 
```
# マイグレーション
rake db:migrate

== 20150627091843 CreateFoodProducts: migrating ===============================
-- create_table(:food_products)
   -> 0.0121s
== 20150627091843 CreateFoodProducts: migrated (0.0122s) ======================
```

## boostrap適用

```
bundle exec rails g bootstrap:themed FoodProducts
```

## バリデーション追加

```
# app/models/food_product.rb

+  validates_presence_of :group_id, :name, :num
+  validates_numericality_of :group_id, :num
```

## topにリンクを追加

```
# app/views/welcome/index.html.erb

+<div class="panel panel-primary">
+  <div class="panel-heading">
+    <h3 class="panel-title">販売食品の登録</h3>
+  </div>
+  <div class="panel-body">
+    模擬店で販売する食品を登録して下さい。<br>
+    対象: 参加形式が「模擬店(食品販売)」の団体
+    <%= link_to t('welcome_controller.index'),
+            food_products_path,
+            :class => 'btn btn-default' %>
+  </div>
+</div>
```

## ActiveAdminの管理対象に追加

```
bundle exec rails generate active_admin:resource FoodProduct

      create  app/admin/food_product.rb
```

`permit_params`を設定し，ActiveAdminからレコードのCURDを許可する
indexメソッドを追加して一覧表示をカスタマイズ
csvメソッドを追加してcsv表示をカスタマイズ

## views/index の編集

* 表示カラムを整理
    * `is_cooking`の表示を変更
* 辞書を`config/locales/01_model/ja.yml`に追加

## controllers/food_product 修正

* ユーザが所有する団体かつ模擬店(食品)のレコードのみを取得させる
    * 該当する団体を`before_action :get_groups`で取得し，`@groups`とする
    * indexメソッドでgroup_idを`@groups`で取得

## views/_form の修正

* スタイルの変更 (テキストボックスを短く，項目名を見やすく)

```
-<%= simple_form_for @food_product, :html => { :class => 'form-horizontal' } do |f| %>
+<%= simple_form_for @food_product, wrapper: "horizontal_form", :html => { :class => 'form-horizontal' } do |f| %>
```

* 選択可能な団体を限定

```
-  <%= f.input :group_id %>
+  <%= f.association :group, collection: @groups, selected: @employee.group_id %>
```

* ヒントを追加

```
-  <%= f.input :name %>
+  <%= f.input :name, hint: t(".hint_name") %>

-  <%= f.input :num %>
+  <%= f.input :num, hint: t(".hint_num") %>

-  <%= f.input :is_cooking %>
+  <%= f.input :is_cooking, hint: t(".hint_is_cooking") %>
```

* ヒントに関連する辞書を追加

```
# config/locales/03_views/ja.yml

+  food_products:
+    form:
+      hint_name: 販売する食品1品の名前を入力して下さい．複数の食品を販売する場合は申請を分割してください．例) たこ焼き
+      hint_num: 販売予定の数量を入力して下さい．
+      hint_is_cooking: どちらかを選択して下さい．
```

* 調理の有無について注意書きを追加
