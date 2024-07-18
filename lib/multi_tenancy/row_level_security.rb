# frozen_literal_string: true

require 'active_support'
require_relative 'schema_statements'

module MultiTenancy
  class RowLevelSecurity
    class << self
      def switch!(tenant_id)
        query = ActiveRecord::Base.sanitize_sql(["SET app.tenant_id = ?", tenant_id])
        ActiveRecord::Base.connection.execute(query)
      end

      def reset!
        ActiveRecord::Base.connection.execute('RESET app.tenant_id;')
      end

      def current
        result = ActiveRecord::Base.connection.execute('SHOW app.tenant_id;')
        result.getvalue(0, 0)
      end
    end
  end
end
