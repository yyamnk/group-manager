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
```
