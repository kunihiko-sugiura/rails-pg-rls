-- アプリケーション用のユーザーを作成
CREATE ROLE app_user LOGIN PASSWORD 'passw0rd';
CREATE ROLE operator_user LOGIN PASSWORD 'passw0rd' CREATEDB;

-- データベースの作成
CREATE DATABASE rls_dev OWNER operator_user;
CREATE DATABASE rls_test OWNER operator_user;

\c rls_dev;
-- schemaの利用権限
GRANT USAGE ON SCHEMA public TO app_user;

\c rls_test;
-- schemaの利用権限
GRANT USAGE ON SCHEMA public TO app_user;
