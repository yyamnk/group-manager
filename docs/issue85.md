<!-- ************** docs/issue85.md **************
Created    : 2016-May-15
Last Change: 2016-May-16.
-->

issue #38 の簡易解決

welcome indexに表示される募集の各パネル (とフォームのURL) を
enable_showカラムで制御する


# モデル生成

```sh
$ bundle exec rails g model ConfigWelcomeIndex name:string panel_partial:string enable_show:boolean
Running via Spring preloader in process 88318
      invoke  active_record
      create    db/migrate/20160515150530_create_config_welcome_indices.rb
      create    app/models/config_welcome_index.rb
```

null: false, defaultを設定

```diff
     create_table :config_welcome_indices do |t|
+      t.string :name, null: false
+      t.string :panel_partial, null: false
+      t.boolean :enable_show, default: false
```

マイグレート

```sh
$ rake db:migrate
== 20160515150530 CreateConfigWelcomeIndices: migrating =======================
-- create_table(:config_welcome_indices)
   -> 0.0208s
== 20160515150530 CreateConfigWelcomeIndices: migrated (0.0209s) ==============
```


# モデル修正

バリデーション追加

# シード追加
