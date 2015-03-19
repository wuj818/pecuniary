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

ActiveRecord::Schema.define(version: 20150319020824) do

  create_table "asset_snapshots", force: :cascade do |t|
    t.integer  "financial_asset_id"
    t.integer  "value",                          default: 0
    t.date     "date"
    t.string   "permalink",          limit: 255
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "asset_snapshots", ["financial_asset_id"], name: "index_asset_snapshots_on_financial_asset_id"
  add_index "asset_snapshots", ["permalink"], name: "index_asset_snapshots_on_permalink", unique: true

  create_table "contributions", force: :cascade do |t|
    t.integer  "financial_asset_id"
    t.integer  "amount",                         default: 0
    t.date     "date"
    t.string   "permalink",          limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "employer",                       default: false
  end

  add_index "contributions", ["employer"], name: "index_contributions_on_employer"
  add_index "contributions", ["financial_asset_id"], name: "index_contributions_on_financial_asset_id"
  add_index "contributions", ["permalink"], name: "index_contributions_on_permalink", unique: true

  create_table "financial_assets", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "permalink",           limit: 255
    t.integer  "current_value",                   default: 0
    t.integer  "total_contributions",             default: 0
    t.boolean  "investment",                      default: true
  end

  add_index "financial_assets", ["permalink"], name: "index_financial_assets_on_permalink", unique: true

  create_table "milestones", force: :cascade do |t|
    t.date     "date"
    t.text     "notes"
    t.string   "permalink",       limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "cached_tag_list"
  end

  add_index "milestones", ["date"], name: "index_milestones_on_date", unique: true
  add_index "milestones", ["permalink"], name: "index_milestones_on_permalink", unique: true

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

end
