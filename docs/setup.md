# SETUP

各環境でアプリを動かす手順

# development環境

```
git clone
cd group_manager
bundle install --path vendor/bundle --jobs=4
rake db:create  # postgresqlのDB作成
rake db:migrate # マイグレーション実行, モデルが生成されてDBに反映される
rake db:seed_fu # 初期値投入
```

環境変数を設定する.
`~/.***rc`に書いとくとよい.

```
export SMTP_ADRESS=smtp.gmail.com
export SMTP_PORT=587
export EMAIL_DOMAIN=gmail.com
export SMTP_AUTH=plain
export SMTP_TLS=false
export EMAIL_USERNAME=<ユーザ名>@gmail.com
export EMAIL_BCC='<BCC送信先>@gmail.com'
export EMAIL_PASSWORD=<パスワード> # gmailの場合は2段階認証を設定後, アプリ固有のパスワードを設定する
export EMAIL_SENDER='送信者名 <ユーザ名@gmail.com>'
export DEFAULT_URL=https://<アプリ名>.herokuapp.com
```

あとは`bundle exec rails s`でサーバ起動, `localholt:3000`でアクセス

# production環境

production環境の設定を全てやる.
追加して

```
# これも`~/.***rc`に書いとくとよい. 自分しか使わないので適当でOK.
export GROUP_MANAGER_DATABASE_PASSWORD=<パスワード>

# postgresqlのユーザ作成( production環境のDBで必要 )
createuser -P -d group_manager 
# ここでパスワードを聞かれるので, $GROUP_MANAGER_DATABASE_PASSWORDと同じものを打つ.

# production環境でDB作成, マイグレーション, 初期値投入
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed_fu RAILS_ENV=production
```

サーバ起動

```
bundle exec rails s -e production
```

# Heroku

## Heroku設定

別アプリ等で設定済みならば省略可

```
heroku login                      # herokuへログイン
heroku keys:add ~/.ssh/id_rsa.pub # ssh公開鍵を登録
```

## アプリを登録

```
heroku apps:create 'アプリ名' --ssh-git
```

`<アプリ名>.herokuapp.com`で公開される

## 環境変数の設定

```
# gmailの設定例
heroku config:set SMTP_ADRESS=smtp.gmail.com
heroku config:set SMTP_PORT=587
heroku config:set EMAIL_DOMAIN=gmail.com
heroku config:set SMTP_AUTH=plain
heroku config:set SMTP_TLS=false
heroku config:set EMAIL_USERNAME=<ユーザ名>@gmail.com
heroku config:set EMAIL_BCC='<BCC送信先>@gmail.com'
heroku config:set EMAIL_PASSWORD=<パスワード> # gmailの場合は2段階認証を設定後, アプリ固有のパスワードを設定する
heroku config:set EMAIL_SENDER='送信者名 <ユーザ名@gmail.com>'
heroku config:set DEFAULT_URL=https://<アプリ名>.herokuapp.com
```

## アプリ送信(初回)

```
git push heroku master     # push
heroku run rake db:create  # DB作成
heroku run rake db:migrate # DB構築
heroku run rake db:seed_fu # 初期値投入
```

proxy環境下等で`heroku run`が使えない場合は`heroku run:detached`を使う.

## アプリ送信(2回目以降)

```
git push heroku master     # push
# 必要ならば
heroku run rake db:migrate # DB構築
heroku run rake db:seed_fu # 初期値投入
```
