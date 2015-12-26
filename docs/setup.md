# SETUP

各環境でアプリを動かす手順

# rubyのインストール
※ 導入するrubyのバージョンは2.2.0  (gemfileで確認して下さい)  
\# mac  
[Homebrewのインストールとrbenvのインストール Mac編]( http://qiita.com/issobero/items/e0443b79da117ed48294)
# postgresqlの準備
```sh
#mac
brew install postgresql

# linux
apt-get install postgresql
# コマンドはこのへんにあるはず
# /usr/lib/postgresql/<バージョン>/bin/
sudo passwd postgres
```

[linuxの場合は個々を参考に](http://ossfan.net/setup/postgresql-20.html)

```sh
# postgresqlのデータベースdirを指定する
export PGDATA=/usr/local/var/postgres # mac
export PGDATA=/var/lib/pgsql/data     # linux

# $PGDATAを初期化
initdb --encoding=UTF-8 --locale=ja_JP.UTF-8
```
ここでmacの人は"もう既にディレクトリがあるよ！"と怒られるかもしれない.
こんなエラーが出たら``/usr/local/var/postgres``ディレクトリを消す.
```sh
#エラー文
initdb: directory "/usr/local/var/postgres" exists but is not empty
If you want toreate a new database system, either remove or empty
the directory "/usr/local/var/postgres" or run initdb
with an argument other than "/usr/local/var/postgres".

# /usr/local/var/postgresを消す
rm -rf /usr/local/var/postgres
```
そしてもう一度``initdb``を行う.
# development環境

```sh
git clone
cd group_manager
bundle install --path vendor/bundle
pg_ctl start
rake db:create  # postgresqlのDB作成
rake db:migrate # マイグレーション実行, モデルが生成されてDBに反映される
rake db:seed_fu # 初期値投入
```

環境変数を設定する.
`~/.***rc`に書いとくとよい.

```sh
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

環境変数を追加, 変更, 削除した場合は  
terminal上で以下を必ず実行する.  
```
# 設定ファイルの再読み込み
source $HOME/.***rc
```


あとは`bundle exec rails s`でサーバ起動,  
`localhost:3000`でアクセス

# production環境

production環境の設定を全てやる.
追加して

```sh
# これも`~/.***rc`に書いとくとよい. 自分しか使わないので適当でOK.
export GROUP_MANAGER_DATABASE_PASSWORD=<パスワード>

# postgresqlのユーザ作成( production環境のDBで必要 )
createuser -P -d group_manager
# ここでパスワードを聞かれるので, $GROUP_MANAGER_DATABASE_PASSWORDと同じものを打つ.

# production環境でDB作成, マイグレーション, 初期値投入
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:seed_fu RAILS_ENV=production

# terminal
$ source ~/.***rc
```

`bundle exec rails s -e production`でサーバ起動,  
`localhost:3000`でアクセス  

```sh 
# エラー
`raise_no_secret_key': Devise.secret_key was not set. Please add the following to your Devise initializer:
```

になった.

[rakeがDevise.secret_key was not setと出て失敗するときの対処法](http://hack.aipo.com/archives/7992/)
を参考に, `config/initializers/devise.rb`に追加する.

ソースにsecret_keyを入れたくない.
環境変数から設定する.

```
# config/initializers/devise.rb

Devise.setup do |config|
    ...
  config.secret_key = ENV['DEVICE_SECRET_KEY']
    ...
``` 

```

# terminal上でsecret_keyを生成
$ rake secret

# ~/.***rcに追加
export DEVICE_SECRET_KEY=<生成したsecret_key>

# terminal
$ source ~/.***rc
```

これで

`bundle exec rails s -e production`でサーバ起動,  
`localhost:3000`にアクセス  

```
# エラー
Missing `secret_token` and `secret_key_base` for 'production' environment, set these values in `config/secrets.yml` 
```

secret_key_baseを追加する   
環境変数から設定する. 

```
# config/secrets.yml
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  ...

# terminalでsecret_keyを生成
$ rake secret

# ~/.***rc 
export SECRET_KEY_BASE=<secret_key>

# terminal
$ source ~/.***rc
```


サーバ起動とアクセス

```sh
bundle exec rails s -e production
```

css, jsがうまく読み込めていない  

[RailsをローカルでProductionモードで起動させる方法](http://ruby-rails.hatenadiary.com/entry/20141110/1415623670)を参考に,  
`~/.***rc`に環境変数を追加する
```
# ~/.***rcに追加
export RAILS_SERVE_STATIC_FILES=true

# terminal 
source ~/.***rc
```

サーバ起動とアクセス

```sh
bundle exec rails s -e production
```

# Heroku

## Heroku設定

別アプリ等で設定済みならば省略可

```sh
heroku login                      # herokuへログイン
heroku keys:add ~/.ssh/id_rsa.pub # ssh公開鍵を登録
```

## アプリを登録

```sh
heroku apps:create 'アプリ名' --ssh-git
```

`<アプリ名>.herokuapp.com`で公開される

## 環境変数の設定

```sh
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

```sh
git push heroku master     # push
heroku run rake db:create  # DB作成
heroku run rake db:migrate # DB構築
heroku run rake db:seed_fu # 初期値投入
```

proxy環境下等で`heroku run`が使えない場合は`heroku run:detached`を使う.

## アプリ送信(2回目以降)

```sh
git push heroku master     # push
# 必要ならば
heroku run rake db:migrate # DB構築
heroku run rake db:seed_fu # 初期値投入
```
