# UserDetail更新をメールする

UserDetailの更新時にメールする
[参考](http://ruby-rails.hatenadiary.com/entry/20140828/1409236436)

```
bundle exec rails g mailer UserDetailMailer 
      create  app/mailers/user_detail_mailer.rb
      create  app/mailers/application_mailer.rb
      invoke  erb
      create    app/views/user_detail_mailer
      create    app/views/layouts/mailer.text.erb
      create    app/views/layouts/mailer.html.erb
```

送信者名をApplicationMailerで設定

```
class ApplicationMailer < ActionMailer::Base

  default from: ENV['EMAIL_SENDER'] # config/initializers/devise.rb と統一

end
```

UserDetailMailer#updateを作成

```
class UserDetailMailer < ApplicationMailer

  def update(user)
    @user = user
    @user_detail = user.user_detail
    mail(to: user.email, subject: '[技大祭]ユーザ情報の更新')
    # 暗黙的にapp/views/user_detail_mailer/update.html.erb がrenderされる.
  end

end
```

送信してみる

```
bundle exec rails c
Loading development environment (Rails 4.2.1)
irb(main):001:0> UserDetailMailer.update(User.first).deliver # 送信できた.
# deliverは使うなと警告される. 
# DEPRECATION WARNING: `#deliver` is deprecated and will be removed in Rails 5. Use `#deliver_now` to deliver immediately or `#deliver_later` to deliver through Active Job.
```

Controllerを編集し, UserDetailの作成, 更新時に`UserDetailMailer.update().deliver_now`を実行させる

```
git diff app/controllers/
diff --git a/app/controllers/user_details_controller.rb b/app/controllers/user_details_controller.rb
index bc99d74..f79e16a 100644
--- a/app/controllers/user_details_controller.rb
+++ b/app/controllers/user_details_controller.rb
@@ -29,6 +29,9 @@ class UserDetailsController < ApplicationController

     respond_to do |format|
       if @user_detail.save
+
+        UserDetailMailer.update(@user_detail).deliver_now # メール送信
+
         format.html { redirect_to @user_detail, notice: 'User detail was successfully created.' }
         format.json { render :show, status: :created, location: @user_detail }
       else
@@ -43,6 +46,9 @@ class UserDetailsController < ApplicationController
   def update
     respond_to do |format|
       if @user_detail.update(user_detail_params)
+
+        UserDetailMailer.update(@user_detail).deliver_now # メール送信
+
         format.html { redirect_to @user_detail, notice: 'User detail was successfully updated.' }
         format.json { render :show, status: :ok, location: @user_detail }% git diff app/controllers/                  [/Volumes/Data/Dropbox/nfes15/group_manager]
```


# Group更新をメールする

基本的に前と同じ作業

```
bundle exec rails g mailer GroupMailer
      create  app/mailers/group_mailer.rb
    conflict  app/mailers/application_mailer.rb
Overwrite /Volumes/Data/Dropbox/nfes15/group_manager/app/mailers/application_mailer.rb? (enter "h" for help) [Ynaqdh] n
        skip  app/mailers/application_mailer.rb
      invoke  erb
      create    app/views/group_mailer
   identical    app/views/layouts/mailer.text.erb
   identical    app/views/layouts/mailer.html.erb
```

* `app/mailers/group_mailer.rb`編集 # GroupMailer#updateを書く
* `app/views/group_mailer/update.html.erb`作成
* `app/controllers/groups_controller.rb`で#create, #update時に`GroupMailer.update().deliver_now`


# herokuアプリのスリープを抑制する

アプリが30minとかで休眠する -> 定期的にping打つ 

```
# Gemfileに`newrelic_rpm`追加
bundle 
heroku config:set NEW_RELIC_APP_NAME="nutfes-group-manager"
heroku config:set NEW_RELIC_LICENSE_KEY="new-relicライセンスキー"
```

# 管理者にメールを転送する

## 背景

現在,
GroupController#create , GroupController#update
UserDetail#create, UserDetail#update
で該当Userにメールを送っている.

このメールを管理者にも転送したい.
roleで判定ではなく, User.get_noticeで制御することにする.

## Userに`get_notice`コラムを追加

```
bundle exec rails g migration AddColumnToUser get_notice:boolean
      invoke  active_record
      create    db/migrate/20150514100412_add_column_to_user.rb
```

デフォルトとnull: falseを設定

```
# db/migrate/20150514100412_add_column_to_user.rb

class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :get_notice, :boolean, null: false, default: false
  end
end
```

```
rake db:migrate
== 20150514100412 AddColumnToUser: migrating ==================================
-- add_column(:users, :get_notice, :boolean, {:null=>false, :default=>false})
   -> 0.0454s
== 20150514100412 AddColumnToUser: migrated (0.0455s) =========================
```

## ActiveAdminでget_noticeを制御可能に

`app/admin/user.rb`を編集

## ApplicationMailerでdefault bccを追加

pluck便利. 該当のカラムで配列にしてくれる.
ActionMailer::Base.defaultには配列で複数アドレスをわたせる.

herokuで送信できてないみたい??
production環境では`GroupMailer.update( Group.last )`のbccが入っていない.

```
be rails c
irb(main):001:0> ApplicationMailer::default[:bcc]
=> ["addrA@gmail.com", "addrB@gmail.com"]
irb(main):002:0> GroupMailer::default[:bcc]
=> ["addrA@gmail.com", "addrB@gmail.com"]
irb(main):003:0> UserDetailMailer::default[:bcc]
=> ["addrA@gmail.com", "addrB@gmail.com"]
```

```
irb(main):001:0> ApplicationMailer.default[:bcc]
=> ["addrB@gmail.com"]
irb(main):002:0> GroupMailer.default[:bcc]
=> ["addrB@gmail.com"]
irb(main):004:0> UserDetailMailer.default[:bcc]
=> ["addrB@gmail.com"]
```

なして...

```
# config/environments/production.rb

  # config.action_mailer.default_url_options = { :host => Rails.application.secrets.default_url }
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
```

でbcc入った. またconfigの環境変数まわりか
一度直打ちでlocalhost:3000をいれたら以後動いた. なして...

herokuも動作がおかしかったが, 再起動かけたら直った.


# データベースのバックアップを自動化

`heroku pg:backups schedule DATABASE_URL --app nutfes-group-manager`
毎日自動バックアップで1週間保持してくれるらしい.

[解説](http://www.mori-soft.com/2008-08-15-01-36-37/os/214-heroku-pgbackups-postgresql)

```
heroku pg:backups public-url
```

で表示されたURLからデータをダウンロードした．
