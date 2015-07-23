# Public: This will create the bank_accounts table in the database.
class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false
      t.decimal :balance, precision: 12, scale: 2, null: false

      t.timestamps null: false
    end
  end
end
