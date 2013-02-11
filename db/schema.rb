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

ActiveRecord::Schema.define(:version => 20130116111114) do

  create_table "ad_fb_comments", :force => true do |t|
    t.string   "fb_comment_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "ads", :force => true do |t|
    t.string   "name"
    t.string   "microsite_url"
    t.string   "image_url"
    t.text     "optin_fields"
    t.integer  "brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.text     "url"
    t.string   "ad_type"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
    t.boolean  "flag",               :default => false
    t.datetime "flagupdate"
    t.boolean  "status",             :default => true
  end

  create_table "ads_users", :force => true do |t|
    t.integer "user_id"
    t.integer "ad_id"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brand_followers", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brand_requests", :force => true do |t|
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_handle"
    t.text     "twitter_info"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "title"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "state_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_dumps", :force => true do |t|
    t.integer  "admin_id"
    t.string   "file_name",  :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dbbackups", :force => true do |t|
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "demo_images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ad_file_name"
    t.string   "ad_content_type"
    t.integer  "ad_file_size"
    t.datetime "ad_updated_at"
  end

  create_table "demos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website_file_name"
    t.string   "website_content_type"
    t.integer  "website_file_size"
    t.datetime "website_updated_at"
    t.text     "info"
    t.string   "url"
    t.text     "adspeed_data"
    t.string   "name"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.boolean  "deliverd",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "brand_id"
  end

  create_table "master_passwords", :force => true do |t|
    t.string   "mpassword"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offers", :force => true do |t|
    t.string   "url"
    t.datetime "expiry_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brand_id"
    t.string   "image_url"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "name"
    t.integer  "radius"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "ad_id"
    t.integer  "city_id"
  end

  create_table "optin_ads", :force => true do |t|
    t.text     "fields"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.integer  "brand_id"
    t.string   "url"
    t.string   "name"
  end

  create_table "purposes", :force => true do |t|
    t.string   "name"
    t.string   "purpose_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "settings", :force => true do |t|
    t.integer  "carousel_refresh"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "name",       :default => ""
    t.string   "purpose_id", :default => ""
    t.text     "content"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "us_states", :id => false, :force => true do |t|
    t.string   "state"
    t.string   "state_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.boolean  "admin",                                 :default => false
    t.string   "zipcode"
    t.string   "username"
    t.string   "notifications"
    t.string   "authentication_token"
    t.boolean  "status",                                :default => true
    t.datetime "statusupdated"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
