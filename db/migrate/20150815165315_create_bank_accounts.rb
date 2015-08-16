# Public: Creates the bank_accounts table in the database.
class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false
      t.decimal :balance, null: false
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
