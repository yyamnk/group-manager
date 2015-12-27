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
