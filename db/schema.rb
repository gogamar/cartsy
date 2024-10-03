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

ActiveRecord::Schema[7.2].define(version: 2024_10_03_101818) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "order_items", force: :cascade do |t|
    t.decimal "price_per_item", precision: 10, scale: 2, null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price_with_discount", precision: 10, scale: 2
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status"
    t.decimal "total_discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pricing_rules", force: :cascade do |t|
    t.string "rule_type"
    t.integer "min_quantity"
    t.decimal "discount_amount", precision: 10, scale: 2
    t.decimal "discount_percentage", precision: 5, scale: 2
    t.integer "free_items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "pricing_rules_products", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "pricing_rule_id", null: false
    t.index ["pricing_rule_id"], name: "index_pricing_rules_products_on_pricing_rule_id"
    t.index ["product_id"], name: "index_pricing_rules_products_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code", null: false
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
end
