# rails-pg-rls
RailsでPostgresのRLS(Row Level Security)によるMulti Tenancyのサンプル。
RLSは行単位のアクセス制限が可能であり、テナント分離に適している。

## このコードでやること
- RLSによるテナント分離の実装
- DB Migration
- Rspecによる実証
- Controllerの実装例に関しては割愛

## 方針
ユーザの分離の方針
アプリケーション用ユーザ(app_user)と
DB操作用ユーザ(operator_user)の分離
ownerにしているが、Bypass RLSの権限を付与しても良い




## 環境
### Ruby version
3.3.4

## 起動方法
### containerの起動方法
```sh
docker compose build
docker compose up
```

### ローカル環境のクリア
DB設定を変更した際に実行する
```sh
docker compose down -v
```



### apiサーバーにshellで入る
```sh
docker exec -it rls-api /bin/bash
```
### container内のRails Consoleに直接入る
```sh
docker exec -it rls-api rails c
```

### DBユーザを操作用ユーザで実行する必要がある
```
DATABASE_USER=operator_user bundle exec rails db:migrate:reset
DATABASE_USER=operator_user bundle exec rails db:migrate
```


### containerへの入り方

### テスト実行

## 補足事項
### railsの初期化
railsはAPIモードで最小構成とする。
```sh
rails new backend \
--database=postgresql \
--skip-action-mailer \
--skip-action-mailbox \
--skip-action-text \
--skip-active-job \
--skip-active-storage \
--skip-action-cable \
-–skip-sprockets \
--skip-javascript \
--skip-hotwire \
--skip-jbuilder \
-–skip-test \
-–skip-system-test \
--api
```
