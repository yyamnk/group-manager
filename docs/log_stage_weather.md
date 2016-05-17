# Stageモデルのレコードの重複をなくす

issue #58

### 問題点

現状のStageだと同じname_jaでもis_sunny = true, falseで2つレコードになってます．

### 解決方法

これは晴天時と雨天時で選択肢を変えたかっただけなので，enable_sunny, enable_rainyにすれば2つレコードを入れる必要が無いです．
現状のStageOrderにstage_idが既に入っているので，移行が必要です．

関連: https://github.com/NUTFes/group-manager/pull/54#issuecomment-218363435

## 作業の前に...

既存の状態でステージ利用の申請データがあることを前提にしています. 
データがない場合は, 移行スクリプトの起動は不要です. 

## Stageテーブルのスキーマ変更

``is_sunny``カラムを廃止  
天候に関する2つのカラムを追加  

* enable_sunny : 晴天時に利用
* enable_rainy : 雨天時に利用

テーブルのカラムを変更するマイグレーションファイルを生成.  

```terminal
$ bundle exec rails g migration ChangeColumnToStage
```

``db/migrate/20160512163238_change_column_to_stage.rb``を以下のように編集.  
```diff
+class ChangeColumnToStage < ActiveRecord::Migration
+  def up
+    remove_column :stages, :is_sunny,     :boolean
+    add_column    :stages, :enable_sunny, :boolean, :default=>false
+    add_column    :stages, :enable_rainy, :boolean, :default=>false
+    change_column :stages, :name_ja,      :string , :null=>false
+  end
+
+  def down
+    add_column    :stages, :is_sunny,     :boolean
+    remove_column :stages, :enable_sunny, :boolean, :default=>nil
+    remove_column :stages, :enable_rainy, :boolean, :default=>nil
+    change_column :stages, :name_ja,      :string , :null=>true
+  end
+end
```


マイグレート

```terminal
$ bundle exec rake db:migrate
```

## Stageモデルのvalidationを変更

``app/models/stage.rb``を編集.

```diff
class Stage < ActiveRecord::Base

validates :name_ja, presence: true
-  validate :name_ja, :uniqueness => { :scope => :is_sunny } # 名前と天候の組み合わせは固有
+  validate :name_ja, :uniqueness => true
+
+  validates :enable_sunny, inclusion: {in: [false,true]}
+  validates :enable_rainy, inclusion: {in: [false,true]}

def to_s # aciveAdmin, simple_formで表示名を指定する
```

## Stageテーブルの全レコードを削除

移行用スクリプトを作成する.  
Stageテーブルの全レコードを削除するタスクを生成

```terminal
$ bundle exec rails g task change_stage_weather_columns
```

``lib/tasks/change_stage_weather_columns.rake``を編集

```diff
namespace :change_stage_weather_columns do
desc "既存のStageOrderからStageの重複データを取り除く"

+  task delete_stage_all_records: :environment do
+    Stage.delete_all
+  end
+
task copy: :environment do
```

スクリプトを実行

```terminal
$ bundle exec rake change_stage_weather_columns:delete_stage_all_records
```

## Seedファイルの変更
```diff
Stage.seed( :id,
-  # 晴天時に使用可能
-  { id: 1 , name_ja: 'メインステージ'         , is_sunny: true } ,
-  { id: 2 , name_ja: 'サブステージ'           , is_sunny: true } ,
-  { id: 3 , name_ja: '体育館'                 , is_sunny: true } ,
-  { id: 4 , name_ja: 'マルチメディアセンター' , is_sunny: true } ,
-  # 雨天時に使用可能
-  { id: 5 , name_ja: '体育館'                 , is_sunny: false } ,
-  { id: 6 , name_ja: 'マルチメディアセンター' , is_sunny: false } ,
-  { id: 7 , name_ja: '武道館'                 , is_sunny: false } ,
+  { id: 1 , name_ja: 'メインステージ'         , enable_sunny: true,  enable_rainy: false } ,
+  { id: 2 , name_ja: 'サブステージ'           , enable_sunny: true,  enable_rainy: false } ,
+  { id: 3 , name_ja: '体育館'                 , enable_sunny: true,  enable_rainy: true  } ,
+  { id: 4 , name_ja: 'マルチメディアセンター' , enable_sunny: true,  enable_rainy: true  } ,
+  { id: 5 , name_ja: '武道館'                 , enable_sunny: true,  enable_rainy: true  } ,
```

## Seedの適応

```terminal
$ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=stage.rb
```

## ステージ申請の選択肢を新規テーブルに合わせて修正

``app/models/stage.rb``を編集

```diff
  def self.by_weather( is_sunny )
-   where( is_sunny: is_sunny )
+   return where( enable_sunny: true ) if is_sunny == true
+   return where( enable_rainy: true ) if is_sunny == false
  end
end
```

## 既存テーブルから新規テーブルへのデータ移行

StageOrderテーブルは, Stageテーブルを参照している.  
つまり, 重複を含むレコードのIDを参照している.  

StageOrderテーブルのデータの整合性を保ったまま,   
Stageテーブルを新しいスキーマ定義に移行する必要がある. 

``lib/tasks/change_stage_weather_columns.rake``を編集



# 本番環境のデータでスクリプトをテスト

本番環境のデータを取得し, スクリプトをテストする  

Herokuからバックアップデータを取ってくる.  
まずは, Herokuのgroup-managerに関してHerokuの管理者にCollaborater設定を行ってもらう.  
Herokuのアカウントがない場合は作成する.  

[stage_common_optionのlog](https://github.com/NUTFes/group-manager/blob/master/docs/log_stage_common_option.md)を参考にした.   

### 本番環境のデータをダウンロード
```terminal
# ログイン
$ heroku login

# nutfes-group-manageがあるか確認
$ heroku apps  

# group-managerのデータベースBackupを確認
# 最新のBackup IDをコピー
$ heroku pg:backups --app nutfes-group-manager
=== Backups
ID    Backup Time                Status                               Size   Database
----  -------------------------  -----------------------------------  -----  --------
a368  2016-05-14 04:38:18 +0000  Completed 2016-05-14 04:38:23 +0000  155kB  JADE
b367  2016-05-13 15:42:19 +0000  Completed 2016-05-13 15:42:23 +0000  155kB  JADE

# ダウンロードURL 生成
$ heroku pg:backups public-url a368 --app nutfes-group-manager
The following URL will expire at 2016-05-14 13:26:34 +0000:
  "https://xfrt...cdd1"

# ダンプファイルとして保存
$ curl "https://xfrt...cdd1" -o a368.dump
```

## ローカルのDBにリストア

``rake db:reset``と``rake db:migrate:reset``の違いは以下
[rake db:reset と rake db:migrate:reset の違い](http://easyramble.com/difference-bettween-rake-db-migrate-reset.html)

```terminal
# 現在のDBをreset 
$ bundle exec rake db:reset 

# データをリストア
$ pg_restore --verbose --clean --no-acl --no-owner -d group_manager_development a368.dump

# 新しいテーブルの適応
$ bundle exec rake db:migrate:reset 

# Stageテーブルのレコードを削除
$ bundle exec rake change_stage_weather_columns:delete_stage_all_records

# Stageテーブルにseedの適応
$ bundle exec rake db:seed_fu FIXTURE_PATH=db/fixtures FILTER=stage.rb

# ユーザへのメール配信機能をoffに
$ bundle exec rails console
 > User.all.each{|user|
 >  user.update(get_notice: false)
 >  } 
#  Ctrl-dでconsoleを閉じる
```

  # 移行スクリプトの実行

  ```terminal
  $ bundle exec rake change_stage_weather_columns:copy
  ```

