# rails-pg-rls
PostgresのRLS(Row Level Security)を利用したMulti TenancyをRailsへ導入するサンプルプログラム。
RLSはテーブルの行単位に対するアクセス制限を可能とし、テナント分離用途で利用される事例が多い。

## このコードでやること
- コンテナによる実行環境の構築
- RLSによるテナント分離の実装
- DB Migrationへの適用
- Rspecによる実証
- Controllerの実装例に関しては割愛

## 方針
### DBユーザの分離
アプリケーション用ユーザ(app_user)と DB操作用ユーザ(operator_user)の分離

| Role          | Grant                          | 用途         　     |
|---------------|--------------------------------|------------------|
| operator_user | SET ROLE(app_user), CREATEDB   | Migration, Rspec |
| app_user      | SELECT, INSERT, UPDATE, DELETE | Application実行    |
※ Rspecはapp_userで実行したいが、insertしたデータを削除するためにoperator_userで実行しテストパターンの実行時にapp_userへ一時的にROLL切り替えする様に対応。

### DB Migration時に適用する権限
- アプリケーション実行のためにtableに対するSELECT, INSERT, UPDATE, DELETE権限をapp_userに付与
- 必要がある場合は、RLSのポリシーを設定

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

### rails実行環境にshellで入る
```sh
docker exec -it rls-api /bin/bash
bundle exec rails db:migrate;
```

container内のRails Consoleに直接入る場合は以下。
```sh
docker exec -it rls-api rails c
```

## テストの実行
railsのcontainerにshellで入った後に以下を実行

```sh
RAILS_ENV=test bundle exec rails db:migrate; bundle exec rspec;
```

## 関連ファイルおよび補足内容
### Container関連
- Container起動時のDB初期化
ユーザ、権限の設定
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/docker-entrypoint-initdb.d/01_init.sql

### Rails設定
- DB接続設定
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/config/database.yml

### RLS関連
- RLSのMigration関連のクエリを定義
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/lib/multi_tenancy/schema_statements.rb

- RLSによるテナントSwitch機能の実装(methodはApartment gemと同様)
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/lib/multi_tenancy/row_level_security.rb

- アプリケーション起動時の設定
ActiveRecordへMigration用にRLS関連の設定のmethodを提供
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/config/application.rb#L32-L34

- ApplicationRecordにRLS関連のmethodを追加
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/app/models/application_record.rb#L6

以下の様にtenantのデータにアクセスする際に利用する、Blockの範囲でtenantのデータにアクセス可能となる。
```rb
ApplicationRecord.with_tenant(tenant.id) do
  # tenantのデータにアクセス
end
```

### Model関連
- Idの生成
uuid型も検討したが、今回サンプルなのでstring型でアプリケーションでuuidを発行するように対応
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/app/models/concerns/generate_id.rb

### Rspec関連
- Rspec実行前にDBをMigrationする設定を無効化

この機能によるmigrationはdb/schema.rbの定義を利用するため、app_userに対するtableのアクセス許可が適用されないことにより、テストが正しく実行できない。
そのため、テストの実行で提示したようにテスト実行前にmigrationを別途実行する必要がある。
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/spec/rails_helper.rb#L27-L32

- テストの実行権限切り替え

テスト毎にデータを削除する必要があるためrspecの実行をoperation_userで実行する。
しかしテストの実行自体はapp_userで実行したい為、テスト実行時にapp_userに切り替える対応を行っている。
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/spec/spec_helper.rb#L111-L117

- RLSのテスト
https://github.com/kunihiko-sugiura/rails-pg-rls/blob/main/spec/models/user_spec.rb#L31-L44
