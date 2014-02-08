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

ActiveRecord::Schema.define(version: 20140206200857) do

  create_table "auctions", force: true do |t|
    t.integer  "product_id"
    t.integer  "image_id"
    t.decimal  "start_price",    precision: 8, scale: 2
    t.decimal  "min_price",      precision: 8, scale: 2
    t.integer  "duration"
    t.integer  "bid_time_step"
    t.decimal  "bid_price_step", precision: 8, scale: 2
    t.datetime "start_time"
    t.decimal  "price",          precision: 8, scale: 2
  end

  add_index "auctions", ["image_id"], name: "index_auctions_on_image_id"
  add_index "auctions", ["product_id"], name: "index_auctions_on_product_id"

  create_table "bids", force: true do |t|
    t.integer "user_id"
    t.integer "auction_id"
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id"
  add_index "bids", ["user_id"], name: "index_bids_on_user_id"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry"

  create_table "images", force: true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "shop_price",  precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_admin",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
