# Public: This creates the incomes table in the database.
class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.references :user, index: true, foreign_key: true
      t.date :budget_date, null: false

      t.timestamps null: false
    end
  end
end
