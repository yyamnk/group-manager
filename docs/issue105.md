# 管理画面からインデックス画面の表示を制御する

## Pull後の作業手順
```
# ConfigUserPermissionのレコードを削除
# 以下のマイグレートで追加する項目がnot nullのため
# 既存のレコードがあるとマイグレーションでエラーが起きる

$ bundle exec rake change_columns_config_user_permission:delete_record

# マイグレート
$ bundle exec rake db:migrate

# 初期値の挿入
$ bundle exec rake db:seed_fu

# 管理画面側から募集状態を制御
$ ConfigUserPermission.update_all(is_accepting:true, is_only_show:false)
```

----------------------------------------------------------------

# 作業の意図
募集状態を制御する機能に, 募集項目を表示する機能を結合する. 

これまでは,ConfigWelcomeIndexテーブルで
WelcomeIndexに表示する画面を制御していた.  

募集状態を制御するConfigUserPermissionが
新しく作成されたため, この機能に表示制御も結合する.   

ConfigUserPermissionで, 
ユーザが使用できる募集項目の閲覧/編集権限, 表示を制御する


# 作業ログ
  
## ConfigUserPermissionにパーシャル名を追加

 * ConfigUserPermissionにパーシャル名を追加
 * ConfigUserPermissionテーブルのレコード削除スクリプトを追加


#### カラム追加用のマイグレーションファイル作成

```
$ bundle exec rails migrate AddColumnToConfigUserPermission
```

#### マイグレーションファイルの編集
```diff
# db/migrate/20160530133525_add_column_to_config_user_permission.rb

+class AddColumnToConfigUserPermission < ActiveRecord::Migration
+  def change
+    add_column :config_user_permissions, :panel_partial, :string, null: false
+  end
+end
```


#### 追加項目にvalidateを追加
```diff
- validates_presence_of :form_name
+ validates_presence_of :form_name, :panel_partial
  validates_uniqueness_of :form_name
+ validates :panel_partial, format: { with: /\w/ }
```

--------------------------------------------------------------------------

## パーシャル名のシード値を追加

```diff
# db/fixtures/config_user_permission.rbを編集

ConfigUserPermission.seed( :id,
-  { id: 1  , form_name: '参加団体'       },
-  { id: 2  , form_name: '副代表'         },
-  { id: 3  , form_name: '物品貸出'       },
-  { id: 4  , form_name: '使用電力'       },
-  { id: 5  , form_name: '実施場所'       },
-  { id: 6  , form_name: 'ステージ利用'   },
-  { id: 7  , form_name: '従業員登録'     },
-  { id: 8  , form_name: '販売食品登録'   },
-  { id: 9  , form_name: '購入リスト登録' },
+  { id: 1  , form_name: '参加団体'       , panel_partial: 'panel_group'},
+  { id: 2  , form_name: '副代表'         , panel_partial: 'panel_sub_rep'},
+  { id: 3  , form_name: '物品貸出'       , panel_partial: 'panel_rental_order'},
+  { id: 4  , form_name: '使用電力'       , panel_partial: 'panel_power_order'},
+  { id: 5  , form_name: '実施場所'       , panel_partial: 'panel_place_order'},
+  { id: 6  , form_name: 'ステージ利用'   , panel_partial: 'panel_stage_order'},
+  { id: 7  , form_name: '従業員登録'     , panel_partial: 'panel_employee'},
+  { id: 8  , form_name: '販売食品登録'   , panel_partial: 'panel_food_product'},
+  { id: 9  , form_name: '購入リスト登録' , panel_partial: 'panel_purchase_list'},
)

```

--------------------------------------------------------------------------
## Welcome Indexの表示制御をConfigUserPermissionで行うように変更

#### コントローラーの編集

```diff
# app/controllers/welcome_controller.rbを編集

- @config_panel = ConfigWelcomeIndex.all.sort
+ # Userが保有するグループ数
+ @group_count = Group.where(user_id: current_user.id).count
```

#### ヘルパーの編集
```diff
# app/helpers/welcome_helper.rbを編集

# 表示するパネルの判定
-  def show_enable_panel(panel, num_nosubrep_groups)
-  # 参加団体，副代表以外は副代表が未登録の団体があれば表示しない
-  if panel.id > 2 && num_nosubrep_groups > 0
-    return
-  end
+  def show_enable_panel(panel, num_nosubrep_groups, group_count)
+
+  # ユーザが参加団体を登録していない場合,
+  # 参加団体を表示
+  return  if panel.id > 1 && group_count == 0
+
+  # もしくは副代表が未登録の場合,
+  # 参加団体と副代表を表示
+  return  if panel.id > 2 && num_nosubrep_groups > 0
+

-  if panel.enable_show
+  # 閲覧, 編集可の場合のみ, 項目を表示する
+  if panel.is_accepting || panel.is_only_show

```

#### ビューの編集

```diff
# app/views/welcome/index.html.erbを編集

-  <%= show_enable_panel(panel, @num_nosubrep_groups) %>
+  <%= show_enable_panel(panel, @num_nosubrep_groups, @group_count) %>
```


--------------------------------------------------------------------------
## Config Welcome IndexをDrop & 管理画面を削除

#### マイグレーションファイルを生成
```
$ bundle exec rails g migration drop_config_welcome_index
```

``db/migrate/20160531155809_drop_config_welcome_index.rb``を編集

```diff

+class DropConfigWelcomeIndex < ActiveRecord::Migration
+  def up
+    drop_table :config_welcome_indices
+  end
+
+  def down
+    create_table :config_welcome_indices do |t|
+      t.string :name, null: false
+      t.string :panel_partial, null: false
+      t.boolean :enable_show, default: false
+      t.timestamps null: false
+    end
+  end
+end
```

#### Config Welcome Indexの管理画面とシードを削除

```terminal
# 管理画面を削除
$ rm app/admin/config_welcome_index.rb 

# モデルを削除
$ rm app/models/config_welcome_index.rb

# シードデータを削除
$ rm db/fixtures/config_welcome_index.rb
```

