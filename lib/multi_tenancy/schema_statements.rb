# frozen_string_literal: true

module MultiTenancy
  module SchemaStatements
    TENANT_POLICY_NAME = 'tenant_policy'

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
