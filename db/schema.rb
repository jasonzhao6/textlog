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

ActiveRecord::Schema.define(version: 20130527224907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer "message_id"
    t.string  "name"
    t.string  "category"
    t.string  "objective"
    t.string  "company_id"
    t.integer "time"
    t.string  "mood"
    t.integer "reps"
  end

  create_table "companies", force: true do |t|
    t.integer "activity_id"
    t.integer "friend_id"
  end

  create_table "friends", force: true do |t|
    t.string "name"
    t.string "fb_id"
  end

  create_table "messages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "body"
    t.boolean  "parsed"
  end

  create_table "rules", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "command"
    t.string   "arg"
  end

end
