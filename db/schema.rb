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

ActiveRecord::Schema.define(version: 20171229070505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",           null: false
    t.text     "summary",        null: false
    t.string   "place",          null: false
    t.string   "place_address",  null: false
    t.datetime "start_datetime", null: false
    t.datetime "end_datetime",   null: false
    t.integer  "capacity",       null: false
    t.integer  "fee"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "participant_managements", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.boolean  "cancel_flag", default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "participant_managements", ["event_id", "user_id"], name: "index_participant_managements_on_event_id_and_user_id", unique: true, using: :btree
  add_index "participant_managements", ["event_id"], name: "index_participant_managements_on_event_id", using: :btree
  add_index "participant_managements", ["user_id"], name: "index_participant_managements_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name",                                   null: false
    t.text     "self_introduction",                      null: false
    t.string   "uid",                    default: "",    null: false
    t.string   "provider",               default: "",    null: false
    t.string   "image_url"
    t.string   "avatar"
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "events", "users"
  add_foreign_key "participant_managements", "events"
  add_foreign_key "participant_managements", "users"
end
