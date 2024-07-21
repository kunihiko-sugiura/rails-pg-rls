require "rails_helper"

RSpec.describe User, type: :model do
  let(:tenant1) { Tenant.create(name: '企業1') }
  let(:tenant2) { Tenant.create(name: '企業2') }

  context 'Validation' do
    it 'nameが存在すること' do
      instance = User.new
      instance.name = 'テスト'
      instance.tenant = tenant1
      expect(instance).to be_valid

      instance.name = nil
      expect(instance).to be_invalid

      instance.name = ''
      expect(instance).to be_invalid
    end
  end

  context 'created' do
    it 'idが発行されること' do
      ApplicationRecord.with_tenant(tenant1.id) do
        instance = User.create(name: '名前', tenant: tenant1)
        expect(instance.id.size).to eq 36
      end
    end
  end

  context 'rls' do
    it '指定したtenantのuserのみアクセス許可される' do
      ApplicationRecord.with_tenant(tenant1.id) do
        User.create(name: '名前1', tenant: tenant1)
      end
      ApplicationRecord.with_tenant(tenant2.id) do
        User.create(name: '名前1', tenant: tenant2)
      end
      ApplicationRecord.with_tenant(tenant1.id) do
        users = User.all
        expect(users.size).to eq 1
        expect(users.first.name).to eq '名前1'
      end
    end
  end
end