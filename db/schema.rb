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

ActiveRecord::Schema.define(:version => 20110211180511) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "mc_code"
    t.integer  "sector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["mc_code"], :name => "index_companies_on_mc_code", :unique => true
  add_index "companies", ["sector_id"], :name => "index_companies_on_sector_id"

  create_table "sectors", :force => true do |t|
    t.string   "name"
    t.string   "mc_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sectors", ["name"], :name => "index_sectors_on_name", :unique => true

end
