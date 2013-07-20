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

ActiveRecord::Schema.define(version: 20130720062954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer "message_id"
    t.string  "activity"
    t.integer "duration"
    t.string  "note"
    t.integer "reps"
    t.float   "distance"
  end

  add_index "activities", ["activity"], name: "index_activities_on_activity", using: :btree
  add_index "activities", ["message_id"], name: "index_activities_on_message_id", using: :btree

  create_table "companies", force: true do |t|
    t.integer "activity_id"
    t.integer "friend_id"
  end

  add_index "companies", ["activity_id"], name: "index_companies_on_activity_id", using: :btree
  add_index "companies", ["friend_id"], name: "index_companies_on_friend_id", using: :btree

  create_table "friends", force: true do |t|
    t.string "name"
    t.string "fb_id"
  end

  add_index "friends", ["fb_id"], name: "index_friends_on_fb_id", using: :btree

  create_table "messages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message"
  end

  create_table "rules", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "matcher_id"
    t.string   "command"
    t.string   "arg"
    t.integer  "cnt",                  default: 0
    t.boolean  "cnt_was_last_updated"
  end

  add_index "rules", ["command"], name: "index_rules_on_command", using: :btree
  add_index "rules", ["matcher_id"], name: "index_rules_on_matcher_id", using: :btree

end
