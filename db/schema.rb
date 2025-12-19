# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_12_08_195404) do
  create_table "advertisements", primary_key: "ad_id", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "city_id", null: false
    t.integer "category_id", null: false
    t.string "status", default: "active", null: false
    t.float "price", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_advertisements_on_city_id"
    t.index ["user_id"], name: "index_advertisements_on_user_id"
  end

  create_table "cities", primary_key: "city_id", force: :cascade do |t|
    t.string "name", null: false
    t.string "region", null: false
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "advertisement_id", null: false
    t.index ["advertisement_id"], name: "index_jobs_on_advertisement_id"
  end

  create_table "real_estates", force: :cascade do |t|
    t.string "type", null: false
    t.float "total_area", null: false
    t.float "living_area", null: false
    t.integer "floor", null: false
    t.integer "total_floors", null: false
    t.integer "rooms_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "advertisement_id", null: false
    t.index ["advertisement_id"], name: "index_real_estates_on_advertisement_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "advertisement_id", null: false
    t.index ["advertisement_id"], name: "index_services_on_advertisement_id"
  end

  create_table "things", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "advertisement_id", null: false
    t.index ["advertisement_id"], name: "index_things_on_advertisement_id"
  end

  create_table "transports", force: :cascade do |t|
    t.string "brand", null: false
    t.string "model", null: false
    t.string "year", null: false
    t.integer "mileage", null: false
    t.string "fuel_type", null: false
    t.string "transmission", null: false
    t.integer "engine_capacity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "advertisement_id", null: false
    t.index ["advertisement_id"], name: "index_transports_on_advertisement_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "city_id"
    t.string "email"
    t.string "password_digest"
    t.string "username"
    t.string "phone"
    t.float "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "advertisements", "cities", primary_key: "city_id"
  add_foreign_key "advertisements", "users"
  add_foreign_key "jobs", "advertisements", primary_key: "ad_id"
  add_foreign_key "real_estates", "advertisements", primary_key: "ad_id"
  add_foreign_key "services", "advertisements", primary_key: "ad_id"
  add_foreign_key "things", "advertisements", primary_key: "ad_id"
  add_foreign_key "transports", "advertisements", primary_key: "ad_id"
end
