"場所申請で行える候補の問題 #35"

## 場所の利用許可を団体カテゴリごとに指定する機能を追加

### 利用可能場所を指定する中間テーブルを生成

モデル生成

```terminal
# 団体カテゴリが利用可能な場所を指定する中間テーブルを生成
$ bundle exec rails g model placeAllowList place:references group_category:references enable:boolean
  Running via Spring preloader in process 27288
    invoke  active_record
    create    db/migrate/20160512083446_create_place_allow_lists.rb
    create    app/models/place_allow_list.rb
```

マイグレート

```terminal
$ bundle exec rake db:migrate
  == 20160512083446 CreatePlaceAllowLists: migrating ============================
-- create_table(:place_allow_lists)
  -> 0.1093s
  == 20160512083446 CreatePlaceAllowLists: migrated (0.1095s) ===================
```

## 既存カラムの訂正
### Placeテーブルからis_outside項目を削除

モデル変更

```terminal
# is_outside項目を削除
$ bundle exec rails g migration RemoveIsOutsideFromPlace is_outside:boolean
  Running via Spring preloader in process 28297
    invoke  active_record
    create    db/migrate/20160512084245_remove_is_outside_from_place.rb
```

マイグレート

```terminal
$ bundle exec rake db:migrate
== 20160512084245 RemoveIsOutsideFromPlace: migrating =========================
-- remove_column(:places, :is_outside, :boolean)
   -> 0.0201s
== 20160512084245 RemoveIsOutsideFromPlace: migrated (0.0204s) ================
```

### モデルにassocitaion, validationを追加

models/place_allow_list.rb

```diff
class PlaceAllowList < ActiveRecord::Base
  belongs_to :place
  belongs_to :group_category
+
+ validates :place_id         , presence: true
+ validates :group_category_id, presence: true
end
```

models/place.rb

```diff
class Place < ActiveRecord::Base
+  has_many :place_allow_lists
```

### 初期値の追加/変更

**PlaceAllowList**
利用可能な場所の中間テーブル用にseedデータを生成
db/fixtures/place_allow_list.rb

```diff
+PlaceAllowList.seed( :id,
+  # 模擬店(食品販売)
+  { id: 1,  place_id: 1,  group_category_id: 1, enable: true  }, #事務棟エリア
+  { id: 2,  place_id: 2,  group_category_id: 1, enable: true  }, #図書館エリア
+  { id: 3,  place_id: 3,  group_category_id: 1, enable: true  }, #福利棟エリア
+  { id: 4,  place_id: 4,  group_category_id: 1, enable: true  }, #ステージエリア
+  { id: 5,  place_id: 5,  group_category_id: 1, enable: true  }, #体育館エリア
+  { id: 6,  place_id: 6,  group_category_id: 1, enable: false }, #セコムホール
+  { id: 7,  place_id: 7,  group_category_id: 1, enable: false }, #電気棟204
+  { id: 8,  place_id: 8,  group_category_id: 1, enable: false }, #電気棟206
+  { id: 9,  place_id: 9,  group_category_id: 1, enable: false }, #電気棟208
+  { id: 10, place_id: 10, group_category_id: 1, enable: false }, #電気棟212
+  { id: 11, place_id: 11, group_category_id: 1, enable: false }, #電気棟310
+  { id: 12, place_id: 12, group_category_id: 1, enable: false }, #講義棟部屋A
+  { id: 13, place_id: 13, group_category_id: 1, enable: false }, #講義棟部屋B
+  { id: 14, place_id: 14, group_category_id: 1, enable: false }, #マルチメディア
+  { id: 15, place_id: 15, group_category_id: 1, enable: false }, #グラウンド
+  # 模擬店(物品販売)
+  { id: 16,  place_id: 1,  group_category_id: 2, enable: true  }, #事務棟エリア
+  { id: 17,  place_id: 2,  group_category_id: 2, enable: true  }, #図書館エリア
+  { id: 18,  place_id: 3,  group_category_id: 2, enable: true  }, #福利棟エリア
+  { id: 19,  place_id: 4,  group_category_id: 2, enable: true  }, #ステージエリア
+  { id: 20,  place_id: 5,  group_category_id: 2, enable: true  }, #体育館エリア
+  { id: 21,  place_id: 6,  group_category_id: 2, enable: false }, #セコムホール
+  { id: 22,  place_id: 7,  group_category_id: 2, enable: false }, #電気棟204
+  { id: 23,  place_id: 8,  group_category_id: 2, enable: false }, #電気棟206
+  { id: 24,  place_id: 9,  group_category_id: 2, enable: false }, #電気棟208
+  { id: 25,  place_id: 10, group_category_id: 2, enable: false }, #電気棟212
+  { id: 26,  place_id: 11, group_category_id: 2, enable: false }, #電気棟310
+  { id: 27,  place_id: 12, group_category_id: 2, enable: true  }, #講義棟部屋A
+  { id: 28,  place_id: 13, group_category_id: 2, enable: true  }, #講義棟部屋B
+  { id: 29,  place_id: 14, group_category_id: 2, enable: false }, #マルチメディア
+  { id: 30,  place_id: 15, group_category_id: 2, enable: false }, #グラウンド
+  # 展示
+  { id: 31,  place_id: 1,  group_category_id: 4, enable: false }, #事務棟エリア
+  { id: 32,  place_id: 2,  group_category_id: 4, enable: false }, #図書館エリア
+  { id: 33,  place_id: 3,  group_category_id: 4, enable: false }, #福利棟エリア
+  { id: 34,  place_id: 4,  group_category_id: 4, enable: false }, #ステージエリア
+  { id: 35,  place_id: 5,  group_category_id: 4, enable: false }, #体育館エリア
+  { id: 36,  place_id: 6,  group_category_id: 4, enable: true  }, #セコムホール
+  { id: 37,  place_id: 7,  group_category_id: 4, enable: false }, #電気棟204
+  { id: 38,  place_id: 8,  group_category_id: 4, enable: false }, #電気棟206
+  { id: 39,  place_id: 9,  group_category_id: 4, enable: false }, #電気棟208
+  { id: 40,  place_id: 10, group_category_id: 4, enable: false }, #電気棟212
+  { id: 41,  place_id: 11, group_category_id: 4, enable: false }, #電気棟310
+  { id: 42,  place_id: 12, group_category_id: 4, enable: true  }, #講義棟部屋A
+  { id: 43,  place_id: 13, group_category_id: 4, enable: true  }, #講義棟部屋B
+  { id: 44,  place_id: 14, group_category_id: 4, enable: true  }, #マルチメディア
+  { id: 45,  place_id: 15, group_category_id: 4, enable: true  }, #グラウンド
+  # その他
+  { id: 46,  place_id: 1,  group_category_id: 5, enable: true }, #事務棟エリア
+  { id: 47,  place_id: 2,  group_category_id: 5, enable: true }, #図書館エリア
+  { id: 48,  place_id: 3,  group_category_id: 5, enable: true }, #福利棟エリア
+  { id: 49,  place_id: 4,  group_category_id: 5, enable: true }, #ステージエリア
+  { id: 50,  place_id: 5,  group_category_id: 5, enable: true }, #体育館エリア
+  { id: 51,  place_id: 6,  group_category_id: 5, enable: true }, #セコムホール
+  { id: 52,  place_id: 7,  group_category_id: 5, enable: false}, #電気棟204
+  { id: 53,  place_id: 8,  group_category_id: 5, enable: false}, #電気棟206
+  { id: 54,  place_id: 9,  group_category_id: 5, enable: false}, #電気棟208
+  { id: 55,  place_id: 10, group_category_id: 5, enable: false}, #電気棟212
+  { id: 56,  place_id: 11, group_category_id: 5, enable: false}, #電気棟310
+  { id: 57,  place_id: 12, group_category_id: 5, enable: true }, #講義棟部屋A
+  { id: 58,  place_id: 13, group_category_id: 5, enable: true }, #講義棟部屋B
+  { id: 59,  place_id: 14, group_category_id: 5, enable: true }, #マルチメディア
+  { id: 60,  place_id: 15, group_category_id: 5, enable: true }, #グラウンド
+)
```

**Place**

Placeテーブルのseedファイルを変更する.
変更点は以下. 

 * 新たな場所を追加した(id:12~15)
 * is_outsideカラムの初期値を削除

 db/fixtures/place.rb

```diff
 Place.seed( :id,
-  # 屋外
-  { id: 1 , name_ja: '事務棟エリア'   , is_outside: true } ,
-  { id: 2 , name_ja: '図書館エリア'   , is_outside: true } ,
-  { id: 3 , name_ja: '福利棟エリア'   , is_outside: true } ,
-  { id: 4 , name_ja: 'ステージエリア' , is_outside: true } ,
-  { id: 5 , name_ja: '体育館エリア'   , is_outside: true } ,
-  # 屋内
-  { id: 6  , name_ja: 'セコムホール' , is_outside: false } ,
-  { id: 7  , name_ja: '電気棟204'    , is_outside: false } ,
-  # 屋内
-  { id: 6  , name_ja: 'セコムホール' , is_outside: false } ,
-  { id: 7  , name_ja: '電気棟204'    , is_outside: false } ,
-  { id: 8  , name_ja: '電気棟206'    , is_outside: false } ,
-  { id: 9  , name_ja: '電気棟208'    , is_outside: false } ,
-  { id: 10 , name_ja: '電気棟212'    , is_outside: false } ,
-  { id: 11 , name_ja: '電気棟310'    , is_outside: false } ,
+  { id: 1 , name_ja: '事務棟エリア'    } ,
+  { id: 2 , name_ja: '図書館エリア'    } ,
+  { id: 3 , name_ja: '福利棟エリア'    } ,
+  { id: 4 , name_ja: 'ステージエリア'  } ,
+  { id: 5 , name_ja: '体育館エリア'    } ,
+  { id: 6  , name_ja: 'セコムホール'   } ,
+  { id: 7  , name_ja: '電気棟204'      } ,
+  { id: 8  , name_ja: '電気棟206'      } ,
+  { id: 9  , name_ja: '電気棟208'      } ,
+  { id: 10 , name_ja: '電気棟212'      } ,
+  { id: 11 , name_ja: '電気棟310'      } ,
+  { id: 12 , name_ja: '講義棟部屋A'    } ,
+  { id: 13 , name_ja: '講義棟部屋B'    } ,
+  { id: 14 , name_ja: 'マルチメディアセンター' } ,
+  { id: 15 , name_ja: 'グラウンド'     },
 )

```

テーブルに初期値を適用

```terminal
$ bundle exec rake db:seed_fu

== Seed from /Users/nakamura_mac/NUTFes/group-manager/db/fixtures/department.rb

  # 結果は省略
``` 

## 入力フォームの修正 

団体が利用可能な場所をDBから取得する方法を変更する.  

```
従来方法:
「団体カテゴリ AND 場所が屋外/屋内(is_outside)」の演算を元に,  
利用可能な場所を判断.  

新規方法: 
「団体カテゴリが利用できる場所」をPlaceAllowListテーブルで定義.  
テーブルを参照し, 利用可能な場所を判断.  
```

models/place.rb

```diff
class Place < ActiveRecord::Base
   has_many :place_allow_lists
   
+  # 団体カテゴリ毎に利用可能な場所を検索する
+  scope :search_enable_place, ->(group_category_id){
+    PlaceAllowList.where(group_category_id: group_category_id, enable : true).map {|allow_place|
+      self.find(allow_place.place_id)
+    }
+
+  }

def to_s # aciveAdmin, simple_formで表示名を指定する
- if self.is_outside
  self.name_ja
- else
-   self.name_ja + " (屋内)"
- end
end

# 選択肢の生成用，団体idで選択可能な場所を返す
  def self.collections(group_id)
    group_category_id = Group.find(group_id).group_category_id
-    # 模擬店は外
-    if [1, 2].include? group_category_id
-      self.where( is_outside: true )
-    elsif [4, 5].include? group_category_id
-    # 展示・体験, その他は屋外 or 屋内
-      self.all
-    end
+    self.search_enable_place(group_category_id)
  end
end
```

## Managerの権限を変更

``cancancan``で Managerの権限を変更する.  

 * developer : PlaceAllowListについてCRUDを許可
 * manager   : Read, Updateのみ許可


app/models/ability.rb

```diff
cannot [:destroy], StockerItem  # 貸出物品在庫は削除不可，0で対応
cannot [:destroy], RentableItem  # 削除不可，0で対応
+ cannot [:create,:destroy], PlaceAllowList #場所の許可に関して編集不可
  end
if user.role_id == 3 then # for user (デフォルトのrole)
  can :manage, :welcome
```

## 管理画面の生成

「場所の利用許可」を管理するための画面を生成する

### 画面生成

```terminal
$ bundle exec rails g active_admin:resource PlaceAllowList
Running via Spring preloader in process 36341
  create  app/admin/place_allow_list.rb
```

### index, editページを変更.   
主にパラメタのpermissionについて変更を加えた.  

 * developer : 団体カテゴリ, 場所, enableを編集可能
 * manager   : enableのみ編集可能


```diff
+ActiveAdmin.register PlaceAllowList do
+
+  # permit_params :enable,:group_category_id,:place
+
+  permit_params do
+    params = [:enable]
+    params.concat [:group_category_id, :place] if current_user.role_id==1
+    params
+  end
+
+  index do
+    id_column
+    column :group_category_id do |order|
+      order.group_category
+    end
+    column :place
+    column :enable
+
+    actions
+  end
+
+  form do |f|
+    inputs '場所を許可/不許可' do
+      if current_user.role_id==1 then
+        input :group_category
+        input :place
+      end
+      input :enable
+    end
+    f.actions
+  end
+
+end
```

管理ページを日本語化  
config/locales/01_model/ja.yml

```diff
stage_order: ステージ利用の申請
place_order: 実施場所の申請
+ place_allow_list: 場所の許可指定
employee: 従業員
food_product: 販売食品
purchase_list: 購入リスト

...

    first: 第一希望
    second: 第二希望
    third: 第三希望
+ place_allow_list:
+   group_category_id: 団体カテゴリ
+   place:             場所
+   enable:            利用許可
  employee:
    group: 運営団体の名称
```

## validationの追加

PlaceAllowListのvalidateが不十分だったため,  
新たにvalidation用のマイグレートファイルを生成.  

```terminal
$ bundle exec rails g migration ChangeValidationToPlaceAllowList
Running via Spring preloader in process 54882
  invoke  active_record
  create    db/migrate/20160512133720_change_validation_to_place_allow_list.rb
```


既存のカラムに対し, 新たなvalidationを追加する. 

```diff
# db/migrate/20160512133720_change_validation_to_place_allow_list.rb

+class ChangeValidationToPlaceAllowList < ActiveRecord::Migration
+ def up
+   change_column :place_allow_lists, :place_id,          :integer, null:false
+   change_column :place_allow_lists, :group_category_id, :integer, null:false
+   change_column :place_allow_lists, :enable,            :boolean, default:false
+   add_index     :place_allow_lists, [:place_id,:group_category_id], :unique=>true
+ end
+
+ def down
+   change_column :place_allow_lists, :place_id,          :integer, null:true, default:nil
+   change_column :place_allow_lists, :group_category_id, :integer, null:true, default:nil
+   change_column :place_allow_lists, :enable,            :boolean, default:nil
+   remove_index  :place_allow_lists, [:place_id,:group_category_id]
+ end
+end
```

マイグレート

```
$ bundle exec rake db:migrate
```

マイグレート後の``db/schema.rb``は以下のようになった.  

```diff
# db/schema.rb
create_table "place_allow_lists", force: :cascade do |t|
-    t.integer  "place_id"
-    t.integer  "group_category_id"
-    t.boolean  "enable"
-    t.datetime "created_at",        null: false
-    t.datetime "updated_at",        null: false
+    t.integer  "place_id",                          null: false
+    t.integer  "group_category_id",                 null: false
+    t.boolean  "enable",            default: false
+    t.datetime "created_at",                        null: false
+    t.datetime "updated_at",                        null: false
end

add_index "place_allow_lists", ["group_category_id"], name: "index_place_allow_lists_on_group_category_id", using: :btree
+  add_index "place_allow_lists", ["place_id", "group_category_id"], name: "index_place_allow_lists_on_place_id_and_group_category_id", unique: true, using: :btree
add_index "place_allow_lists", ["place_id"], name: "index_place_allow_lists_on_place_id", using: :btree
```

## モデルのvalidateを追加

app/models/place_allow_list.rb

```diff
class PlaceAllowList < ActiveRecord::Base

  validates :place_id         , presence: true
  validates :group_category_id, presence: true
+ validates :place_id         , uniqueness: { scope: [:group_category_id] }
end
```
