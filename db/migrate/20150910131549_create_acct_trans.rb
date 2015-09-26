# Public: Creates the acct_trans database table.
class CreateAcctTrans < ActiveRecord::Migration
  def change
    create_table :acct_trans do |t|
      t.references :bank_account, index: true, foreign_key: true
      t.string :trans_type, null: false
      t.decimal :trans_amount, null: false
      t.string :description
      t.date :trans_date, null: false

      t.timestamps null: false
    end
  end
end
