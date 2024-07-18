# frozen_string_literal: true

module MultiTenancy
  module SchemaStatements
    TENANT_POLICY_NAME = 'tenant_policy'
    SCHEMA_NAME = 'public'
    # TODO: 設定を共通化したい
    APP_USER_NAME = 'app_user'

    # Tableに対する権限の付与: Table追加時に指定
    def grant_table(table_name)
      puts APP_USER_NAME
      execute "GRANT SELECT, INSERT, UPDATE, DELETE ON #{table_name} TO #{APP_USER_NAME};"
    end

    # Tableに対する権限の削除
    def revoke_table(table_name)
      execute "REVOKE SELECT, INSERT, UPDATE, DELETE ON #{table_name} FROM #{APP_USER_NAME};"
    end

    # Tableのsequenceに対する権限の付与: idにsequenceを利用したTable追加時に指定
    def grant_sequence(table_name)
      execute "GRANT USAGE ON #{table_name}_id_seq TO #{APP_USER_NAME};"
    end

    def remove_sequence(table_name)
      execute "REVOKE USAGE ON #{table_name}_id_seq TO #{APP_USER_NAME};"
    end

    # Tableに対するRLSの権限付与: RLSが必要なTable追加時に指定
    def create_rls_policy(table_name)
      execute <<~SQL
        ALTER TABLE #{table_name} ENABLE ROW LEVEL SECURITY;
        ALTER TABLE #{table_name} FORCE ROW LEVEL SECURITY;
      SQL
      execute <<~SQL
        CREATE POLICY #{TENANT_POLICY_NAME} ON #{table_name}
          AS PERMISSIVE
          FOR ALL
          TO PUBLIC
          USING (tenant_id = NULLIF(current_setting('app.tenant_id'), '')::VARCHAR)
          WITH CHECK (tenant_id = NULLIF(current_setting('app.tenant_id'), '')::VARCHAR)
      SQL
    end

    # Tableに対するRLSの権限削除
    def drop_rls_policy(table_name)
      execute <<~SQL
        ALTER TABLE #{table_name} NO FORCE ROW LEVEL SECURITY;
        ALTER TABLE #{table_name} DISABLE ROW LEVEL SECURITY;
      SQL
      execute <<~SQL
        DROP POLICY #{TENANT_POLICY_NAME} ON #{table_name}
      SQL
    end
  end
end
