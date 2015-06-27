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
