# SETUP

各環境でアプリを動かす手順

# development環境

# production環境

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
