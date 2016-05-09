https://github.com/NUTFes/group-manager/issues/34
の修正

# DB修正

```sh
$ bundle exec rails g migration AddManufacturerToPowerOrders manufacturer:string model:string
Running via Spring preloader in process 68658
      invoke  active_record
      create    db/migrate/20160509121757_add_manufacturer_to_power_orders.rb
$ bundle exec rails g migration ChangeColumnsToPowerOrders

$ rake db:migrate
== 20160509121757 AddManufacturerToPowerOrders: migrating =====================
-- add_column(:power_orders, :manufacturer, :string, {:null=>false, :default=>"No Data"})
   -> 0.0341s
-- add_column(:power_orders, :model, :string, {:null=>false, :default=>"No Data"})
   -> 0.0046s
== 20160509121757 AddManufacturerToPowerOrders: migrated (0.0389s) ============

== 20160509122328 ChangeColumnsToPowerOrders: migrating =======================
-- change_column_default(:power_orders, :manufacturer, nil)
   -> 0.0022s
-- change_column_default(:power_orders, :model, nil)
   -> 0.0012s
== 20160509122328 ChangeColumnsToPowerOrders: migrated (0.0035s) ==============
```

## 解説的なもの

`db/migrate/20160509121757_add_manufacturer_to_power_orders.rb`で
* カラムを追加
* null: false, デフォルト値: 'none'
を設定し，マイグレーション実行時に既存レコードの`manufacturerer`, `model`を`none`にする．

`db/migrate/20160509122328_change_columns_to_power_orders.rb`で
* デフォルト値を`nil`にし，未入力でのレコード作成を抑制


# モデル修正

```diff
 class PowerOrder < ActiveRecord::Base
   belongs_to :group

-  validates :group_id, :item, :power, presence: true # 必須項目
+  validates :group_id, :item, :power, :manufacturer, :model, presence: true # 必須項目
   validates :power, numericality: { # 整数のみ, [1-1000]
     only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000,
   }
```

バリデーション追加
