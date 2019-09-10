# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_10_134750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "planet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["planet_id"], name: "index_favorites_on_planet_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "moons", force: :cascade do |t|
    t.bigint "planet_id", null: false
    t.string "name"
    t.boolean "isPlanet"
    t.integer "density"
    t.integer "gravity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["planet_id"], name: "index_moons_on_planet_id"
  end

  create_table "planets", force: :cascade do |t|
    t.string "name"
    t.string "latin_name"
    t.boolean "isPlanet"
    t.integer "gravity"
    t.integer "density"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "info"
    t.integer "distanceFromSun"
    t.boolean "withInSolarSystem"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
  end

  add_foreign_key "favorites", "planets"
  add_foreign_key "favorites", "users"
  add_foreign_key "moons", "planets"
end
