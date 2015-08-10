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

ActiveRecord::Schema.define(version: 20141028205428) do

  create_table "crits", force: :cascade do |t|
    t.integer  "page_id"
    t.text     "comment"
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "deleted_at"
  end

  add_index "crits", ["deleted_at"], name: "index_crits_on_deleted_at"
  add_index "crits", ["page_id"], name: "index_crits_on_page_id"
  add_index "crits", ["user_id"], name: "index_crits_on_user_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "pages", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "url"
    t.string   "title"
    t.string   "screenshot"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "processed",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "crits_count", default: 0,     null: false
    t.datetime "deleted_at"
  end

  add_index "pages", ["deleted_at"], name: "index_pages_on_deleted_at"
  add_index "pages", ["project_id"], name: "index_pages_on_project_id"

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "thumbnail"
    t.string   "share_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pages_count", default: 0,    null: false
    t.integer  "crits_count", default: 0,    null: false
    t.boolean  "private",     default: true, null: false
    t.datetime "deleted_at"
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at"
  add_index "projects", ["share_id"], name: "index_projects_on_share_id"
  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "punches", force: :cascade do |t|
    t.integer  "punchable_id",                          null: false
    t.string   "punchable_type", limit: 20,             null: false
    t.datetime "starts_at",                             null: false
    t.datetime "ends_at",                               null: false
    t.datetime "average_time",                          null: false
    t.integer  "hits",                      default: 1, null: false
  end

  add_index "punches", ["average_time"], name: "index_punches_on_average_time"
  add_index "punches", ["punchable_type", "punchable_id"], name: "punchable_index"

  create_table "users", force: :cascade do |t|
    t.string   "email",      default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
