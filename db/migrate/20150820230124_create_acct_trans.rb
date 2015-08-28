# Public: This creates the acct_trans table in the database.
class CreateAcctTrans < ActiveRecord::Migration
  def change
    create_table :acct_trans do |t|
      t.references :bank_account, index: true, foreign_key: true
      t.references :transactable, polymorphic: true, index: true
      t.text :trans_type, null: false
      t.decimal :trans_amount, null: false
      t.text :description
      t.date :trans_date, null: false

      t.timestamps null: false
    end
  end
end
