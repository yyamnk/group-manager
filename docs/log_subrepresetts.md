<!-- ************** docs/log_subrepresetts.md **************
Created    : 2015-Dec-25
Last Change: 2015-Dec-27.
-->


副代表の追加

## CURD

```sh
$ bundle exec rails g scaffold SubRep group:references name_ja:string name_en:string department:references grade:references tel:string email:string
      invoke  active_record
      create    db/migrate/20151225141723_create_sub_reps.rb
      create    app/models/sub_rep.rb
      invoke  resource_route
       route    resources :sub_reps
      invoke  scaffold_controller
      create    app/controllers/sub_reps_controller.rb
      invoke    erb
      create      app/views/sub_reps
      create      app/views/sub_reps/index.html.erb
      create      app/views/sub_reps/edit.html.erb
      create      app/views/sub_reps/show.html.erb
      create      app/views/sub_reps/new.html.erb
      create      app/views/sub_reps/_form.html.erb
      invoke    helper
      create      app/helpers/sub_reps_helper.rb
      invoke    jbuilder
      create      app/views/sub_reps/index.json.jbuilder
      create      app/views/sub_reps/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/sub_reps.coffee
      invoke    scss
      create      app/assets/stylesheets/sub_reps.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss

$ vim db/migrate/20151225141723_create_sub_reps.rb
# null 制約を追加
$ rake db:migrate
== 20151225141723 CreateSubReps: migrating ====================================
-- create_table(:sub_reps)
   -> 0.0626s
== 20151225141723 CreateSubReps: migrated (0.0627s) ===========================
```

ここまで`8931b96`


## バリデート追加

```diff
@@ -2,4 +2,16 @@ class SubRep < ActiveRecord::Base
   belongs_to :group
   belongs_to :department
   belongs_to :grade
+
+  # 必須入力
+  validates :group_id, :name_ja, :name_en, :tel, :email, :department_id, :grade_id,
+    presence: true
+
+  # 半角英字と半角スペースのみ
+  validates :name_en, format: { with: /\A[a-zA-Z\s]+\z/i }
+
+  # tel -> 半角数字とハイフンのみ, ( [333-4444-4444, for 携帯], [4444-22-4444, for 固定] )
+  validates :tel, format: { with: /(\A\d{3}-\d{4}-\d{4}+\z)|(\A\d{4}-\d{2}-\d{4})+\z/i }
+
+  validates :email, :email_format => { :message => '有効なe-mailアドレスを入力してください' }
```

## 副代表の入力画面をDashboardに追加

```diff
--- a/app/views/welcome/index.html.erb
+++ b/app/views/welcome/index.html.erb
@@ -17,6 +17,19 @@

+<div class="panel panel-primary">
+  <div class="panel-heading">
+    <h3 class="panel-title">副代表</h3>
+  </div>
+  <div class="panel-body">
+    参加団体の副代表を追加・編集します。<br>
+    対象: 全ての団体
+    <%= link_to t('welcome_controller.index'),
+            sub_reps_path,
+            :class => 'btn btn-default' %>
+  </div>
+</div>
+
 <div class="panel panel-primary">
   <div class="panel-heading">
     <h3 class="panel-title">物品貸出</h3>
   </div>
```

## bootstrap適用

```sh
$ bundle exec rails g bootstrap:themed SubReps
    conflict  app/views/sub_reps/index.html.erb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/views/sub_reps/index.html.erb? (enter "h" for help) [Ynaqdh] a
       force  app/views/sub_reps/index.html.erb
    conflict  app/views/sub_reps/new.html.erb
       force  app/views/sub_reps/new.html.erb
    conflict  app/views/sub_reps/edit.html.erb
       force  app/views/sub_reps/edit.html.erb
    conflict  app/views/sub_reps/_form.html.erb
       force  app/views/sub_reps/_form.html.erb
    conflict  app/views/sub_reps/show.html.erb
       force  app/views/sub_reps/show.html.erb
```

### index表示項目を整理

* 不要な項目の削除
    - id
* 表示内容の変更
    - `group`
    - `department`
    - `grade`

### _formの編集

* 関連項目の変更 (`f.input` から`f.association`へ)
    - group, `views/employee/_form...`を参考に
        - コントローラで`@groups`を取得
    - department, grade, `views/user_detail/_form`を参考に

## 編集権限を付加

* cancancan
    - `models/ability.rb`で`SubRep`の権限を設定
* コントローラ
    - `controllers/sub_reps_controller.rb`に`load_and_authorize_resource`を追記
        - これでcancancanの設定が反映される

## 各種申請時に副代表の登録を必須にする

`cancancan`で編集可能なレコードを変更．
ユーザが所有していて，副代表が登録済みのgroup_idのみに権限を与える

## 各種申請時に選択可能な参加団体を変更

副代表が登録されている団体のみを選択肢として与える．

## 副代表登録の警告文を追加

副代表が登録されていない団体がある場合にwarningを表示させる

`app/views/shared/_warning_subrep.html.erb`を作成
このパーシャルを`welcome/index`, `sub_reps/index.html.erb`で表示

## 副代表のテーブルをactive adminの管理対象へ追加

```sh
$ bundle exec rails generate active_admin:resource SubRep
      create  app/admin/sub_rep.rb
```
