-- migrationなどの操作ユーザの作成(DB所有者)
CREATE ROLE operator_user LOGIN PASSWORD 'passw0rd' CREATEDB;
-- アプリケーション実行ユーザーの作成
CREATE ROLE app_user LOGIN PASSWORD 'passw0rd';

-- operator_userがapp_userの権限で操作可能(Rspec実行時に利用)
GRANT app_user TO operator_user;

-- データベースの作成
CREATE DATABASE rls_dev OWNER operator_user;
CREATE DATABASE rls_test OWNER operator_user;

-- 開発用
\c rls_dev;
-- schema作成
CREATE SCHEMA my_app AUTHORIZATION operator_user;
-- app_userへのschemaの利用権限
GRANT USAGE ON SCHEMA my_app TO app_user;
-- アプリケーション用schemaにテーブルが追加された際にmy_appへテーブルへ必要な権限を付与
ALTER DEFAULT PRIVILEGES FOR ROLE operator_user IN SCHEMA my_app
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

-- テスト用
\c rls_test;
-- schema作成
CREATE SCHEMA my_app AUTHORIZATION operator_user;
-- app_userへのschemaの利用権限
GRANT USAGE ON SCHEMA my_app TO app_user;
-- アプリケーション用schemaにテーブルが追加された際にmy_appへテーブルへ必要な権限を付与
ALTER DEFAULT PRIVILEGES FOR ROLE operator_user IN SCHEMA my_app
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
