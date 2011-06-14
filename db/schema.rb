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

ActiveRecord::Schema.define(:version => 20110610111334) do

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "association_id"
    t.string   "association_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",          :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["association_id", "association_type"], :name => "association_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "currencies", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "code",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "symbol"
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code", :unique => true, :case_sensitive => false
  add_index "currencies", ["name"], :name => "index_currencies_on_name", :unique => true, :case_sensitive => false

  create_table "formulation_ingredients", :force => true do |t|
    t.integer  "formulation_item_id"
    t.integer  "ingredient_id"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "formulation_ingredients", ["formulation_item_id"], :name => "index_formulation_ingredients_on_formulation_item_id"

  create_table "formulation_items", :force => true do |t|
    t.integer  "formulation_id", :null => false
    t.integer  "compound_id",    :null => false
    t.string   "compound_type",  :null => false
    t.float    "quantity",       :null => false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "formulation_items", ["compound_type", "compound_id"], :name => "index_formulation_items_on_compound_type_and_compound_id"
  add_index "formulation_items", ["formulation_id"], :name => "index_formulation_items_on_formulation_id"

  create_table "formulations", :force => true do |t|
    t.string   "type"
    t.string   "code"
    t.string   "name"
    t.string   "state"
    t.integer  "owner_id"
    t.text     "top_note"
    t.text     "middle_note"
    t.text     "base_note"
    t.integer  "product_year"
    t.string   "origin_formula_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "formulations", ["owner_id"], :name => "index_formulations_on_owner_id"
  add_index "formulations", ["state"], :name => "index_formulations_on_state"
  add_index "formulations", ["type"], :name => "index_formulations_on_type"
  add_index "formulations", ["code"], :name => "index_formulations_on_code", :unique => true, :case_sensitive => false

  create_table "forumlation_items", :force => true do |t|
    t.integer  "formulation_id"
    t.integer  "compound_id"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tax_id"
    t.integer  "custom_duty_id"
  end

  add_index "ingredients", ["custom_duty_id"], :name => "index_ingredients_on_custom_duty_id"
  add_index "ingredients", ["tax_id"], :name => "index_ingredients_on_tax_id"
  add_index "ingredients", ["code"], :name => "index_ingredients_on_code", :unique => true, :case_sensitive => false

  create_table "levies", :force => true do |t|
    t.string   "type",       :null => false
    t.string   "name",       :null => false
    t.float    "amount",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "levies", ["type", "name"], :name => "index_levies_on_type_and_name", :unique => true, :case_sensitive => false

  create_table "price_currencies", :force => true do |t|
    t.integer  "price_id"
    t.string   "currency_code"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "price_currencies", ["price_id", "currency_code"], :name => "index_price_currencies_on_price_id_and_currency_code", :unique => true

  create_table "prices", :force => true do |t|
    t.integer  "priceable_id"
    t.string   "priceable_type"
    t.float    "inr"
    t.float    "usd"
    t.float    "eur"
    t.date     "as_on",                             :null => false
    t.boolean  "calculated",                        :null => false
    t.boolean  "latest",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["priceable_type", "priceable_id"], :name => "index_prices_on_priceable_type_and_priceable_id"

  create_table "users", :force => true do |t|
    t.string   "prefix",              :null => false
    t.string   "first_name",          :null => false
    t.string   "last_name",           :null => false
    t.string   "email",               :null => false
    t.string   "crypted_password",    :null => false
    t.string   "password_salt",       :null => false
    t.string   "persistence_token",   :null => false
    t.string   "single_access_token", :null => false
    t.string   "perishable_token",    :null => false
    t.string   "time_zone"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true, :case_sensitive => false
  add_index "users", ["prefix"], :name => "index_users_on_prefix", :unique => true, :case_sensitive => false

  add_foreign_key "formulation_ingredients", ["formulation_item_id"], "formulation_items", ["id"], :on_delete => :cascade, :name => "formulation_ingredients_formulation_item_id_fkey"

  add_foreign_key "formulation_items", ["formulation_id"], "formulations", ["id"], :on_delete => :cascade, :name => "formulation_items_formulation_id_fkey"

  add_foreign_key "ingredients", ["tax_id"], "levies", ["id"], :on_delete => :restrict, :name => "ingredients_tax_id_fkey"
  add_foreign_key "ingredients", ["custom_duty_id"], "levies", ["id"], :on_delete => :restrict, :name => "ingredients_custom_duty_id_fkey"

end
