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

ActiveRecord::Schema[8.0].define(version: 2025_05_28_082419) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_no"
    t.string "email"
    t.string "password_digest"
    t.string "country"
    t.string "state"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_cart_items_on_account_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.boolean "is_featured", default: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "product_id", null: false
    t.index ["category_id", "product_id"], name: "index_categories_products_on_category_id_and_product_id"
    t.index ["product_id", "category_id"], name: "index_categories_products_on_product_id_and_category_id"
  end

  create_table "chat_request_notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.boolean "accepted"
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "account_id", null: false
    t.bigint "chat_room_id", null: false
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["account_id"], name: "index_messages_on_account_id"
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "order_id"
    t.string "title"
    t.text "message"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.bigint "chat_room_id"
    t.index ["account_id"], name: "index_notifications_on_account_id"
    t.index ["chat_room_id"], name: "index_notifications_on_chat_room_id"
    t.index ["order_id"], name: "index_notifications_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "order_notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "total_price"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tracking_status", default: 0
    t.index ["account_id"], name: "index_orders_on_account_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.text "description"
    t.string "price"
    t.bigint "brand_id"
    t.text "product_description"
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "title"
    t.integer "rating"
    t.bigint "account_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_reviews_on_account_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end

  add_foreign_key "cart_items", "accounts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "messages", "accounts"
  add_foreign_key "messages", "chat_rooms"
  add_foreign_key "notifications", "accounts"
  add_foreign_key "notifications", "chat_rooms"
  add_foreign_key "notifications", "orders"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "accounts"
  add_foreign_key "products", "brands"
  add_foreign_key "reviews", "accounts"
  add_foreign_key "reviews", "products"
end
