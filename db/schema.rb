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

ActiveRecord::Schema.define(:version => 20140721210300) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "url"
    t.string   "credential"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "chunks", :force => true do |t|
    t.datetime "begin"
    t.datetime "end"
    t.float    "completion_rate"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "format"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  create_table "labels", :force => true do |t|
    t.string   "name"
    t.datetime "timestamp"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "records", :force => true do |t|
    t.datetime "begin"
    t.datetime "end"
    t.string   "filename"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "records", ["filename"], :name => "index_records_on_filename"

  create_table "releases", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "checksum"
    t.string   "description_url"
    t.string   "status"
    t.datetime "status_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "download_size"
    t.integer  "url_size"
  end

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "storage_limit"
  end

  create_table "uploads", :force => true do |t|
    t.string   "file"
    t.string   "status"
    t.datetime "retry_at"
    t.integer  "retry_count"
    t.string   "type"
    t.integer  "account_id"
    t.string   "target"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
