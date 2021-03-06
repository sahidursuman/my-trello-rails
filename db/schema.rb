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

ActiveRecord::Schema.define(version: 20170222190158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "board_id"
    t.boolean "admin",    default: false
    t.boolean "owner",    default: false
  end

  create_table "boards", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "boards", ["token"], name: "index_boards_on_token", using: :btree

  create_table "card_watchings", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.jsonb    "activities"
    t.jsonb    "checklists"
    t.string   "token"
  end

  add_index "cards", ["activities"], name: "index_cards_on_activities", using: :gin
  add_index "cards", ["checklists"], name: "index_cards_on_checklists", using: :gin
  add_index "cards", ["token"], name: "index_cards_on_token", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string   "title"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "token"
  end

  add_index "lists", ["token"], name: "index_lists_on_token", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.string   "reference_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "remote_id",  null: false
    t.string   "token",      null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "secret",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_digest"
    t.boolean  "activated",              default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "system_admin",           default: false
    t.string   "stripe_customer_id"
    t.string   "plan"
    t.string   "stripe_subscription_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
