# Public: This will create the acct_transactions table in the database.
class CreateAcctTransactions < ActiveRecord::Migration
  def change
    create_table :acct_transactions do |t|
      t.references :bank_account, index: true, foreign_key: true
      t.string :trans_type, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :description, null: false

      t.timestamps null: false
    end
  end
end
