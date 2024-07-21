require "rails_helper"

RSpec.describe Tenant, type: :model do
  context 'Validation' do
    it 'nameが存在すること' do

      instance = Tenant.new
      instance.name = 'テスト'
      expect(instance).to be_valid

      instance.name = nil
      expect(instance).to be_invalid

      instance.name = ''
      expect(instance).to be_invalid
    end
  end

  context 'created' do
    it 'idが発行されること' do
      instance = Tenant.create(name: '企業1')
      expect(instance.id.size).to eq 36
    end
  end
end