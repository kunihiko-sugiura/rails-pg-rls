class CreateTenant < ActiveRecord::Migration[7.1]
  TABLE_NAME = 'tenants'.freeze

  def change
    create_table :tenants, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.string :name, null: false, default: ''

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        grant_table(TABLE_NAME)
      end
      dir.down do
        revoke_table(TABLE_NAME)
      end
    end
  end
end
