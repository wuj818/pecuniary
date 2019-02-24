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

ActiveRecord::Schema.define(version: 2018_12_14_220358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contributions", force: :cascade do |t|
    t.bigint "financial_asset_id"
    t.bigint "amount", default: 0
    t.date "date"
    t.text "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "employer", default: false
    t.index ["employer"], name: "idx_33855_index_contributions_on_employer"
    t.index ["financial_asset_id"], name: "idx_33855_index_contributions_on_financial_asset_id"
    t.index ["permalink"], name: "idx_33855_index_contributions_on_permalink", unique: true
  end

  create_table "financial_assets", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "permalink"
    t.bigint "current_value", default: 0
    t.bigint "total_contributions", default: 0
    t.boolean "investment", default: true
    t.index ["permalink"], name: "idx_33843_index_financial_assets_on_permalink", unique: true
  end

  create_table "milestones", force: :cascade do |t|
    t.date "date"
    t.text "notes"
    t.text "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "cached_tag_list"
    t.index ["date"], name: "idx_33866_index_milestones_on_date", unique: true
    t.index ["permalink"], name: "idx_33866_index_milestones_on_permalink", unique: true
  end

  create_table "snapshots", force: :cascade do |t|
    t.bigint "financial_asset_id"
    t.bigint "value", default: 0
    t.date "date"
    t.text "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["financial_asset_id"], name: "idx_33833_index_snapshots_on_financial_asset_id"
    t.index ["permalink"], name: "idx_33833_index_snapshots_on_permalink", unique: true
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.text "taggable_type"
    t.bigint "tagger_id"
    t.text "tagger_type"
    t.text "context"
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "idx_33885_taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "idx_33885_index_taggings_on_taggable_id_and_taggable_type_and_c"
  end

  create_table "tags", force: :cascade do |t|
    t.text "name"
    t.bigint "taggings_count", default: 0
    t.index ["name"], name: "idx_33875_index_tags_on_name", unique: true
  end

end
