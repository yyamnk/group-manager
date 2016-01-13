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
分かりにくい気がする．．．

```
<br><h4>ステージ利用における詳細</h4>こちらもご入力ください．
    <%= link_to t('welcome_controller.index'),
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

# View



