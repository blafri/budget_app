# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150820230124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acct_trans", force: :cascade do |t|
    t.integer  "bank_account_id"
    t.integer  "transactable_id"
    t.string   "transactable_type"
    t.text     "trans_type",        null: false
    t.decimal  "trans_amount",      null: false
    t.text     "description"
    t.date     "trans_date",        null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "acct_trans", ["bank_account_id"], name: "index_acct_trans_on_bank_account_id", using: :btree
  add_index "acct_trans", ["transactable_type", "transactable_id"], name: "index_acct_trans_on_transactable_type_and_transactable_id", using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                      null: false
    t.decimal  "balance",                   null: false
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "bank_accounts", ["user_id"], name: "index_bank_accounts_on_user_id", using: :btree

  create_table "buckets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "buckets", ["user_id"], name: "index_buckets_on_user_id", using: :btree

  create_table "incomes", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "budget_date", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "incomes", ["user_id"], name: "index_incomes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "acct_trans", "bank_accounts"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "buckets", "users"
  add_foreign_key "incomes", "users"
end
