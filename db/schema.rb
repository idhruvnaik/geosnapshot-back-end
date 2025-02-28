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

ActiveRecord::Schema[7.1].define(version: 2025_02_01_125428) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "food_category_status", ["active", "inactive"]
  create_enum "food_item_status", ["active", "inactive"]
  create_enum "order_status", ["pending", "inprogress", "cancel", "ready", "canceled"]
  create_enum "serving_table_status", ["active", "inactive"]

  create_table "food_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image"
    t.string "token"
    t.enum "status", default: "inactive", null: false, enum_type: "food_category_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "food_items", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.enum "status", default: "inactive", null: false, enum_type: "food_item_status"
    t.text "description"
    t.string "serving"
    t.bigint "food_category_id", null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price", default: 0.0
    t.index ["food_category_id"], name: "index_food_items_on_food_category_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "token"
    t.bigint "food_item_id", null: false
    t.float "quantity"
    t.bigint "order_id", null: false
    t.float "price"
    t.string "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_item_id"], name: "index_order_items_on_food_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "token"
    t.bigint "serving_table_id", null: false
    t.enum "status", default: "pending", null: false, enum_type: "order_status"
    t.float "total_price"
    t.string "estimated_time"
    t.datetime "submission_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serving_table_id"], name: "index_orders_on_serving_table_id"
  end

  create_table "serving_tables", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.string "location"
    t.enum "status", default: "inactive", null: false, enum_type: "serving_table_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "food_items", "food_categories"
  add_foreign_key "order_items", "food_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "serving_tables"
end
