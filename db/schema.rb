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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130504075440) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "favorites", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "http_proxies", :force => true do |t|
    t.string   "ip"
    t.integer  "port"
    t.integer  "speed",        :default => 50
    t.boolean  "available",    :default => false
    t.integer  "country"
    t.datetime "last_used_at"
    t.datetime "verified_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "http_proxies", ["ip", "port"], :name => "ip_port_uniq_idx"
  add_index "http_proxies", ["verified_at", "speed"], :name => "verify_speed_idx"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "proxy_sources", :force => true do |t|
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "proxy_sources", ["url"], :name => "url_idx", :unique => true

  create_table "stock_quotes", :force => true do |t|
    t.string   "symbol",                          :limit => 10
    t.string   "name"
    t.string   "market_capitalization"
    t.float    "last_trade_price_only"
    t.string   "change_with_percent_change"
    t.float    "previous_close"
    t.string   "day_range"
    t.string   "fifty_two_week_range"
    t.integer  "average_daily_volume"
    t.float    "short_ratio"
    t.float    "p_e_ratio"
    t.float    "price_eps_estimate_current_year"
    t.float    "price_eps_estimate_next_year"
    t.float    "peg_ratio"
    t.float    "one_yr_target_price"
    t.float    "dividend_per_share"
    t.float    "book_value"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "stocks", :force => true do |t|
    t.string   "ticker"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "ename"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "code"
    t.integer  "parent_id"
    t.integer  "weibo_rank",   :default => 0
    t.float    "weibo_score",  :default => 0.0
    t.integer  "google_rank",  :default => 0
    t.integer  "google_score", :default => 0
    t.integer  "cn21_rank",    :default => 0
    t.integer  "cn21_score",   :default => 0
    t.float    "final_score",  :default => 0.0
    t.integer  "soso_rank",    :default => 0
    t.integer  "soso_score",   :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "nick_name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
