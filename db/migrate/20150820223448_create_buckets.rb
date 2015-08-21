# Public: This creates the buckets table in the database.
class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
