<!-- ************** docs/log_extend2annual.md **************
Created    : 2015-Dec-27
Last Change: 2015-Dec-27.
-->

システムを年次対応させる

* DBの変更
    - 開催年のテーブルを新規に作成, `FesYear`
    - FesDateテーブルとFesYearに紐付け
    - 各団体をFesYearに紐付け
* 表示の変更
    - `controllers/group_base.rb`で団体idの取得時に年度を指定する
        - デフォルトはその年の(アクセスした日時の年)
        - 一般ユーザ(利用者, `role_id = 3`)は前年度のデータは見れないことにする
            - 将来的には見えるようにするべきかも．

# FesYearをCURD

```sh
$ bundle exec rails g model FesYear fes_year:integer
```

`db/migrate/20151227120540_create_fes_years.rb`で
`null: false`を追加

```sh
$ rake db:migrate
== 20151227120540 CreateFesYears: migrating ===================================
-- create_table(:fes_years)
   -> 0.0038s
== 20151227120540 CreateFesYears: migrated (0.0039s) ==========================
```

# ActiveAdminの管理対象へ追加

```sh
$ bundle exec rails generate active_admin:resource FesYear
      create  app/admin/fes_year.rb
```

`app/admin/fes_year.rb`を編集．
`parmit_params`, `index`を追記

# seed追加

```sh
$ vim db/fixtures/fes_year.rb
$ rake db:seed_fu
```

# FesDateにFesYearを関連付け

```sh
$ bundle exec rails g migration AddFesYearToFesDate fes_year:references
      invoke  active_record
      create    db/migrate/20151227123846_add_fes_year_to_fes_date.rb

$ rake db:migrate
== 20151227123846 AddFesYearToFesDate: migrating ==============================
-- add_reference(:fes_dates, :fes_year, {:index=>true, :foreign_key=>true})
   -> 0.0098s
== 20151227123846 AddFesYearToFesDate: migrated (0.0099s) =====================
```

* seed変更
    - `../db/fixtures/fes_year_date.rb` # fes_dateより先にfes_yearのseedを加える
* model リレーション追加
    - `../app/models/fes_date.rb`
    - `../app/models/fes_year.rb`

# 団体とFesYearを関連付け

```sh
$ bundle exec rails g migration AddFesYearToGroup fes_year:references
      invoke  active_record
      create    db/migrate/20151227124815_add_fes_year_to_group.rb
$ rake db:migrate 
== 20151227124815 AddFesYearToGroup: migrating ================================
-- add_reference(:groups, :fes_year, {:index=>true, :foreign_key=>true})
   -> 0.0094s
== 20151227124815 AddFesYearToGroup: migrated (0.0095s) =======================
```

## モデルで関連付け

```diff
 class Group < ActiveRecord::Base
   belongs_to :group_category
   belongs_to :user
+  belongs_to :fes_year
   has_many :sub_reps
```
