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

ActiveRecord::Schema[7.0].define(version: 2022_07_05_024602) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contributions", force: :cascade do |t|
    t.bigint "financial_asset_id"
    t.bigint "amount", default: 0
    t.date "date"
    t.text "permalink"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "employer", default: false
    t.index ["employer"], name: "index_contributions_on_employer"
    t.index ["financial_asset_id"], name: "index_contributions_on_financial_asset_id"
    t.index ["permalink"], name: "index_contributions_on_permalink", unique: true
  end

  create_table "financial_assets", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "permalink"
    t.bigint "current_value", default: 0
    t.bigint "total_contributions", default: 0
    t.boolean "investment", default: true
    t.index ["permalink"], name: "index_financial_assets_on_permalink", unique: true
  end

  create_table "milestones", force: :cascade do |t|
    t.date "date"
    t.text "notes"
    t.text "permalink"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "cached_tag_list"
    t.index ["date"], name: "index_milestones_on_date", unique: true
    t.index ["permalink"], name: "index_milestones_on_permalink", unique: true
  end

  create_table "snapshots", force: :cascade do |t|
    t.bigint "financial_asset_id"
    t.bigint "value", default: 0
    t.date "date"
    t.text "permalink"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["financial_asset_id"], name: "index_snapshots_on_financial_asset_id"
    t.index ["permalink"], name: "index_snapshots_on_permalink", unique: true
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.text "taggable_type"
    t.bigint "tagger_id"
    t.text "tagger_type"
    t.text "context"
    t.datetime "created_at", precision: nil
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", force: :cascade do |t|
    t.text "name"
    t.bigint "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
