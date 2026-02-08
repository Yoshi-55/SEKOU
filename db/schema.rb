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

ActiveRecord::Schema[7.1].define(version: 2026_02_08_092935) do
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

  create_table "applies", force: :cascade do |t|
    t.text "message", null: false
    t.integer "status", default: 0, null: false
    t.datetime "applied_at"
    t.datetime "responded_at"
    t.bigint "job_id", null: false
    t.bigint "craftsman_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["craftsman_id"], name: "index_applies_on_craftsman_id"
    t.index ["job_id", "craftsman_id"], name: "index_applies_on_job_id_and_craftsman_id", unique: true
    t.index ["job_id"], name: "index_applies_on_job_id"
    t.index ["status"], name: "index_applies_on_status"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_memberships_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "job_type", null: false
    t.string "location", null: false
    t.text "address"
    t.integer "budget", null: false
    t.date "scheduled_date", null: false
    t.integer "required_people", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.datetime "published_at"
    t.datetime "expires_at"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.index ["client_id"], name: "index_jobs_on_client_id"
    t.index ["group_id"], name: "index_jobs_on_group_id"
    t.index ["job_type"], name: "index_jobs_on_job_type"
    t.index ["location"], name: "index_jobs_on_location"
    t.index ["published_at"], name: "index_jobs_on_published_at"
    t.index ["status"], name: "index_jobs_on_status"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount", null: false
    t.string "stripe_charge_id"
    t.integer "status", default: 0, null: false
    t.integer "base_price", null: false
    t.integer "featured_price", default: 0
    t.integer "urgent_price", default: 0
    t.integer "extended_price", default: 0
    t.datetime "paid_at"
    t.bigint "job_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_session_id"
    t.index ["job_id"], name: "index_payments_on_job_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["stripe_charge_id"], name: "index_payments_on_stripe_charge_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "phone", null: false
    t.string "company_name"
    t.text "company_address"
    t.string "stripe_customer_id"
    t.string "prefecture"
    t.text "skills"
    t.text "bio"
    t.integer "years_of_experience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applies", "jobs"
  add_foreign_key "applies", "users", column: "craftsman_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "jobs", "groups"
  add_foreign_key "jobs", "users", column: "client_id"
  add_foreign_key "payments", "jobs"
end
