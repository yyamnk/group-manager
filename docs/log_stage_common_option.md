ステージ利用団体の共通項目を分離 #19

# scaffold

```
$ bundle exec rails g scaffold StageCommonOption group:references own_equipment:boolean bgm:boolean camera_permittion:boolean loud_sound:boolean stage_content:text
      invoke  active_record
      create    db/migrate/20160113115058_create_stage_common_options.rb
      create    app/models/stage_common_option.rb
      invoke  resource_route
       route    resources :stage_common_options
      invoke  scaffold_controller
      create    app/controllers/stage_common_options_controller.rb
      invoke    erb
      create      app/views/stage_common_options
      create      app/views/stage_common_options/index.html.erb
      create      app/views/stage_common_options/edit.html.erb
      create      app/views/stage_common_options/show.html.erb
      create      app/views/stage_common_options/new.html.erb
      create      app/views/stage_common_options/_form.html.erb
      invoke    helper
      create      app/helpers/stage_common_options_helper.rb
      invoke    jbuilder
      create      app/views/stage_common_options/index.json.jbuilder
      create      app/views/stage_common_options/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/stage_common_options.coffee
      invoke    scss
      create      app/assets/stylesheets/stage_common_options.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss
```

# migration

migrationファイルを記述

```
$ vim db/migrate/20160113115058_create_stage_common_options.rb

# null制約を追加
class CreateStageCommonOptions < ActiveRecord::Migration
  def change
    create_table :stage_common_options do |t|
      t.references :group, index: true, foreign_key: true, null: false
      t.boolean :own_equipment
      t.boolean :bgm
      t.boolean :camera_permittion
      t.boolean :loud_sound
      t.text :stage_content, null: false

      t.timestamps null: false
    end
  end
end


```

# migrate

```
$ rake db:migrate
== 20160113030135 CreateStageCommonOptions: migrating =========================
-- create_table(:stage_common_options)
   -> 0.0150s
== 20160113030135 CreateStageCommonOptions: migrated (0.0150s) ================
```

# validates
`app/models/stage_common_option.rb`にvalidationを記述

```
@@ -1,3 +1,9 @@
 class StageCommonOption < ActiveRecord::Base
   belongs_to :group
+
+  # 存在チェック
+  validates :group_id, :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content, presence: true
+
+  # 団体毎にユニーク
+  validates :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content, :uniqueness => {:scope => [:group_id] }
```

# Welcome index　にlinkを貼る


```
<br>対象: 参加形式が「ステージ企画」の団体
    <%= link_to t('ステージ利用の詳細'),
            stage_common_options_path,
            :class => 'btn btn-default' %>
```

# bootstrapを適用

```
$ bundle exec rails g bootstrap:themed StageCommonOptions
    conflict  app/views/stage_common_options/index.html.erb
Overwrite /Users/kkoike/Development/rails_projects/group-manager/app/views/stage_common_options/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/stage_common_options/index.html.erb
    conflict  app/views/stage_common_options/new.html.erb
       force  app/views/stage_common_options/new.html.erb
    conflict  app/views/stage_common_options/edit.html.erb
       force  app/views/stage_common_options/edit.html.erb
    conflict  app/views/stage_common_options/_form.html.erb
       force  app/views/stage_common_options/_form.html.erb
    conflict  app/views/stage_common_options/show.html.erb
       force  app/views/stage_common_options/show.html.erb
```

# DBの更新
過去のDB構造のままだったので全部消してから更新

```
$ rake db:migrate:reset		# DB内容全部消して，作成
$ rake db:seed_fu			# 初期データの挿入
```

# Viewの整理
以下2ファイルを更新

```
app/views/stage_common_options/_form.html.erb
app/views/stage_common_options/index.html.erb
```

辞書データの更新

```
config/locales/01_model/ja.yml
```

# 団体作成時に初期レコードを作成させる
ステージ利用団体は必ず情報を入力することになるので，団体作成時に初期レコードを作成するようにする．

app/models/group.rb

```
def init_stage_common_option # StageCommonOptionのレコードが無ければ登録
  return unless group_category_id == 3 # ステージ企画でなければ戻る
  order = StageCommonOption.new( group_id: id, stage_content: '未回答' )
  order.save
end
```

app/controllers/groups_controller

```
# createとupdateに追加
@group.init_stage_common_option # ステージ企画の共通項目のレコードを生成
```

# 再度Viewの整理
初期レコードが生成されるようになったので，

- `Newボタン`を消す  
- edit画面にて，出演内容に未回答と表示されてしまうので`_form.html.erb`を編集

```
 <%= f.input :stage_content, input_html: { value: '' }%>
```

- update時`show.html.erb`
	* group_id 消す
	* ○×表記

# 団体に属するレコードを取得するように
Controllerを編集

```
class StageCommonOptionsController < GroupBase	# GroupBase を継承

  def index
    @stage_common_options = StageCommonOption.where(group_id: @groups)
  end
```

# 権限の設定
models/ability.rb

```
if user.role_id == 3 then # for user (デフォルトのrole)

...(省略)...

# ステージ利用共通項目は自分の団体のみ自由に触れる．
can [:new, :create, :update, :read], StageCommonOption, :group_id => groups

...

```


stage_common_option_controller.rb

```
load_and_authorize_resource # <= 追加
```

# 既存DBから新規DBへの移行スクリプト
`copy`

`StageOrder`テーブルから

- "own_equipment"
- "bgm"
- "camera_permittion"
- "loud_sound"

の４つを`StageCommonOption`テーブルにコピーする．コピー元のカラムは消さない

rakeタスクの作成

```
$ bundle exec rails g task stage_common_options
```

`lib/tasks/stage_common_options.rb`を編集

```
namespace :stage_common_options do
  desc "既存のStageOrderから共通項目をStageCommonOptionに移行"

  task copy: :environment do
    # 各グループのStageOrderの1日目晴れの情報をStageCommonOptionへコピー
    groups = Group.where(group_category_id: 3)

    groups.each{ |group|
      stage_order = StageOrder.where(group_id: group.id).first # 配列で返ってくるので .first で先頭要素を取得
      option = StageCommonOption.new({ group_id: stage_order.group_id,
      								   own_equipment: stage_order.own_equipment,
		      						   bgm: stage_order.bgm,
		      						   camera_permittion: stage_order.camera_permittion,
		      						   loud_sound: stage_order.loud_sound,
		      						   stage_content: 'NO DATA' }) if (StageCommonOption.where(group_id: group.id) == []) # データが存在しない場合実行
      
      option.save if (StageCommonOption.where(group_id: group.id) == [])
    }
  end
end
```


実行

```
$ bundle exec rake stage_common_options:copy
```

# その他移行作業
## 既存フォーム（Stage_Option）の編集
- 共通項目の入力欄を削除

`app/views/stage_orders/_form.html.erb`  

```git
-  <%= error_span(@stage_order[:time]) %>
-  <%= f.input :own_equipment %>
-  <%= error_span(@stage_order[:own_equipment]) %>
-  <%= f.input :bgm %>
-  <%= error_span(@stage_order[:bgm]) %>
-  <%= f.input :camera_permittion %>
-  <%= error_span(@stage_order[:camera_permittion]) %>
-  <%= f.input :loud_sound %>
-  <%= error_span(@stage_order[:loud_sound]) %>
```

## DevelopmentUserになる
管理画面の変更が必要になるため，DevelopmentUserになっておく．


```
$ bundle exec rails c
[1] pry(main)> user = User.find(1)
[2] pry(main)> user.role_id = 1
[3] pry(main)> user.save
```

これで，`id:1`のユーザがDevelopmentUserになった．

## 管理画面の編集
### ステージ利用の申請（Stage_Option）からダウンロードするcsvファイルに，StageCommonOptionの内容を付加する．

`app/admin/stage_oders.rb`

```git
+    column("自前の音響機材を使用する") {|order| StageCommonOption.where(group_id: order.group_id).first.own_equipment ? "Yes" : "No" }
+    column("実行委員にBGMをかけるのを依頼する") {|order| StageCommonOption.where(group_id: order.group_id).first.bgm ? "Yes" : "No" }
+    column("実行委員による撮影を許可する") {|order| StageCommonOption.where(group_id: order.group_id).first.camera_permittion ? "Yes" : "No" }
+    column("大きな音を出す") {|order| StageCommonOption.where(group_id: order.group_id).first.loud_sound ? "Yes" : "No" }
+    column("出演内容") {|order| StageCommonOption.where(group_id: order.group_id).first.stage_content }
```

### ステージ利用の詳細（StageCommonOption）の一覧ページをカスタマイズ

- create_time,update_timeを消す．

`app/admin/stage_common_option.rb`

```
permit_params :group, :own_equipment, :bgm, :camera_permittion, :loud_sound, :stage_content # 編集可能な属性の設定

  index do
    selectable_column
    id_column
    column :group
    column :own_equipment do |order|
      order.own_equipment ? "Yes" : "No"
    end
    column :bgm do |order|
      order.bgm ? "Yes" : "No"
    end
    column :camera_permittion do |order|
      order.camera_permittion ? "Yes" : "No"
    end
    column :loud_sound do |order|
      order.loud_sound ? "Yes" : "No"
    end
    column :stage_content do |order|
      order.stage_content
    end
    actions
  end
```

### ステージ利用の詳細（StageCommonOption）からダウンロードするcsvファイルの設定

`app/admin/stage_common_option.rb`

```ruby
csv do
  column :id
  column :group_name do  |order|
    order.group.name
  end
  column :own_equipment do  |order|
    order.own_equipment ? "Yes" : "No"
  end
  column :bgm do  |order|
    order.bgm ? "Yes" : "No"
  end
  column :camera_permittion do  |order|
    order.camera_permittion ? "Yes" : "No"
  end
  column :loud_sound do  |order|
    order.loud_sound ? "Yes" : "No"
  end
  column :stage_content do  |order|
    order.stage_content
  end
end
```



