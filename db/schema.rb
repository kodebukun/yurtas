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

ActiveRecord::Schema.define(version: 2026_01_03_083052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_points", force: :cascade do |t|
    t.string "ssid", null: false
    t.integer "inspection_room_id", null: false
    t.string "password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "anonymous_comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "user_id", null: false
    t.integer "anonymous_post_id", null: false
    t.string "nickname", null: false
    t.string "position", default: "neutral", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "safety", default: "safe", null: false
  end

  create_table "anonymous_posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.integer "user_id"
    t.boolean "resolved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "safety", default: "safe", null: false
    t.boolean "discuss", default: false, null: false
  end

  create_table "breaches", force: :cascade do |t|
    t.text "content", null: false
    t.integer "user_id", null: false
    t.integer "anonymous_post_id"
    t.integer "anonymous_comment_id"
    t.boolean "approval", default: false, null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.integer "user_id", null: false
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "morning_id"
    t.integer "diary_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name", null: false
    t.string "os", null: false
    t.integer "security_soft_id"
    t.integer "user_id"
    t.string "device_type", null: false
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diaries", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.integer "user_id"
    t.integer "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "designated_date", null: false
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "anonymous_post_id"
    t.boolean "agreement", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.bigint "post_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_type"
    t.string "file_name", default: "default_name", null: false
    t.bigint "department_id"
    t.index ["post_id"], name: "index_images_on_post_id"
  end

  create_table "incidents", force: :cascade do |t|
    t.string "shift", null: false
    t.datetime "occurred_at", null: false
    t.integer "department_id", null: false
    t.string "place", null: false
    t.integer "years", null: false
    t.string "target", null: false
    t.string "happened", null: false
    t.text "response"
    t.text "measure"
    t.text "excuse"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.boolean "checked", default: false
  end

  create_table "inspection_rooms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id"
    t.integer "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "morning_id"
    t.integer "diary_id"
    t.integer "anonymous_comment_id"
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "name", null: false
    t.integer "manufacturer_id"
    t.string "place"
    t.string "use"
    t.date "install_date"
    t.date "update_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "material_type"
    t.integer "department_id"
  end

  create_table "mornings", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.integer "user_id", null: false
    t.string "absentee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "visitor_id", null: false
    t.integer "visited_id", null: false
    t.integer "post_id"
    t.integer "comment_id"
    t.string "action", default: "", null: false
    t.boolean "checked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "morning_id"
    t.integer "diary_id"
    t.integer "anonymous_post_id"
    t.integer "anonymous_comment_id"
    t.index ["anonymous_comment_id"], name: "index_notifications_on_anonymous_comment_id"
    t.index ["anonymous_post_id"], name: "index_notifications_on_anonymous_post_id"
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["morning_id"], name: "index_notifications_on_morning_id"
    t.index ["post_id"], name: "index_notifications_on_post_id"
    t.index ["visited_id"], name: "index_notifications_on_visited_id"
    t.index ["visitor_id"], name: "index_notifications_on_visitor_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.integer "user_id"
    t.integer "work_id"
    t.integer "department_id"
    t.boolean "meeting", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rule", default: false, null: false
  end

  create_table "rankings", force: :cascade do |t|
    t.integer "rank", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "security_softs", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unreads", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id"
    t.integer "anonymous_post_id"
    t.integer "department_id"
    t.integer "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "incident_id"
  end

  create_table "user_access_points", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "access_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_point_id"], name: "index_user_access_points_on_access_point_id"
    t.index ["user_id"], name: "index_user_access_points_on_user_id"
  end

  create_table "user_departments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_user_departments_on_department_id"
    t.index ["user_id"], name: "index_user_departments_on_user_id"
  end

  create_table "user_positions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_id"], name: "index_user_positions_on_position_id"
    t.index ["user_id"], name: "index_user_positions_on_user_id"
  end

  create_table "user_works", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_works_on_user_id"
    t.index ["work_id"], name: "index_user_works_on_work_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.integer "login_id", null: false
    t.string "password_digest", null: false
    t.string "email", null: false
    t.string "phone_no"
    t.string "image_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "night_shift", default: false, null: false
    t.boolean "day_shift", default: false, null: false
    t.boolean "call", default: false, null: false
    t.string "comment"
  end

  create_table "works", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "images", "posts"
  add_foreign_key "user_access_points", "access_points"
  add_foreign_key "user_access_points", "users"
  add_foreign_key "user_departments", "departments"
  add_foreign_key "user_departments", "users"
  add_foreign_key "user_positions", "positions"
  add_foreign_key "user_positions", "users"
  add_foreign_key "user_works", "users"
  add_foreign_key "user_works", "works"
end
