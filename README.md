# rails-pg-rls
RailsでPostgreSQLのRLSを使うサンプル

## 環境
### Ruby version
3.3.4

### containerの起動方法

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
