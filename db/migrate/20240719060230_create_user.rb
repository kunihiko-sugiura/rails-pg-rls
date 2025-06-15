class CreateUser < ActiveRecord::Migration[7.1]
  TABLE_NAME = 'users'.freeze

  def change
    create_table :users, id: false do |t|
      t.string :id, limit: 36, primary_key: true
      t.string :name, null: false, default: ''
      t.references :tenant, null: false, type: :string, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        create_rls_policy(TABLE_NAME)
      end
      dir.down do
        drop_rls_policy(TABLE_NAME)
      end
    end
  end
end
