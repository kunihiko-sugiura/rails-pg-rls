class CreateTenant < ActiveRecord::Migration[7.1]
  TABLE_NAME = 'tenants'.freeze

  def change
    create_table :tenants, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.string :name, null: false, default: ''

      t.timestamps
    end
  end
end
