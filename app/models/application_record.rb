class ApplicationRecord < ActiveRecord::Base
  include MultiTenancy

  primary_abstract_class

  def self.with_tenant(tenant_id)
    RowLevelSecurity.switch!(tenant_id)
    yield
  ensure
    RowLevelSecurity.reset!
  end
end
