# 従業員の募集項目作成ログ

## 基本方針

食品販売に関わる団体に従業員を登録させる．

employee_categoryモデルに担当部門を入れる．
employeeモデルに団体id，名前，学生番号，担当部門idを入れる．

## モデル生成

```
# 担当部門用
bundle exec rails g model employee_category name_ja:string name_en:string

# マイグレーション
rake db:migrate
== 20150620135916 CreateEmployeeCategories: migrating =========================
-- create_table(:employee_categories)
   -> 0.0047s
== 20150620135916 CreateEmployeeCategories: migrated (0.0048s) ================

# 初期データ投入
rake db:seed_fu
```

## CURD生成

```
bundle exec rails g scaffold employee group:references name:string student_id:integer employee_category:references duplication:boolean
```

`db/migrate/***_create_employees.rb`で`name`, `student_id`を`null: false`で指定．

```
# マイグレーション
rake db:migrate

== 20150620141736 CreateEmployees: migrating ==================================
-- create_table(:employees)
   -> 0.0215s
== 20150620141736 CreateEmployees: migrated (0.0215s) =========================
```

## boostrap適用

```
bundle exec rails g bootstrap:themed Employees

    conflict  app/views/employees/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/employees/index.html.erb? (enter "h" for help) [Ynaqdh] a       
    force  app/views/employees/index.html.erb
    conflict  app/views/employees/new.html.erb
       force  app/views/employees/new.html.erb
    conflict  app/views/employees/edit.html.erb
       force  app/views/employees/edit.html.erb
    conflict  app/views/employees/_form.html.erb
       force  app/views/employees/_form.html.erb
    conflict  app/views/employees/show.html.erb
       force  app/views/employees/show.html.erb
```
