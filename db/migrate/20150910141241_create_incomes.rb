# Public: Creates the incomes database table.
class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :budget_month, null: false
      t.references :acct_tran, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
