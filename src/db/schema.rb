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

ActiveRecord::Schema.define(version: 2021_08_27_020440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "drive_time_destinations", force: :cascade do |t|
    t.integer "destination_id"
    t.string "route_destination"
    t.integer "min_route_time"
    t.integer "travel_time"
    t.integer "delay"
    t.bigint "drive_time_origin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["drive_time_origin_id"], name: "index_drive_time_destinations_on_drive_time_origin_id"
  end

  create_table "drive_time_origins", force: :cascade do |t|
    t.integer "origin_id"
    t.string "location_name"
    t.string "lat"
    t.string "lon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "routes", force: :cascade do |t|
    t.string "route_color"
    t.boolean "frequent_service"
    t.integer "route_number"
    t.integer "route_id"
    t.string "route_type"
    t.string "desc"
    t.integer "route_sort_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "brand_id", null: false
    t.index ["brand_id"], name: "index_routes_on_brand_id"
  end

  create_table "share_station_statuses", force: :cascade do |t|
    t.string "station_id"
    t.integer "num_docks_available"
    t.integer "is_returning"
    t.integer "is_installed"
    t.integer "num_bikes_available"
    t.integer "is_renting"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "brand_id", null: false
    t.bigint "share_station_id", null: false
    t.index ["brand_id"], name: "index_share_station_statuses_on_brand_id"
    t.index ["share_station_id"], name: "index_share_station_statuses_on_share_station_id"
  end

  create_table "share_stations", force: :cascade do |t|
    t.string "lat"
    t.string "lon"
    t.integer "capacity"
    t.string "name"
    t.string "station_uuid"
    t.bigint "brand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_share_stations_on_brand_id"
  end

  create_table "shares", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.string "lat"
    t.string "lon"
    t.string "bike_uuid"
    t.integer "disabled"
    t.integer "reserved"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_shares_on_brand_id"
  end

  add_foreign_key "drive_time_destinations", "drive_time_origins"
  add_foreign_key "routes", "brands"
  add_foreign_key "share_station_statuses", "brands"
  add_foreign_key "share_station_statuses", "share_stations"
  add_foreign_key "share_stations", "brands"
  add_foreign_key "shares", "brands"
end
