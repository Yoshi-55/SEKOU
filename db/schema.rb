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

ActiveRecord::Schema[7.1].define(version: 2026_01_27_070514) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "job_type", null: false
    t.string "location", null: false
    t.text "address"
    t.integer "budget", null: false
    t.date "scheduled_date", null: false
    t.integer "required_people", default: 1, null: false
    t.boolean "featured", default: false, null: false
    t.boolean "urgent", default: false, null: false
    t.boolean "extended_period", default: false, null: false
    t.integer "status", default: 0, null: false
    t.datetime "published_at"
    t.datetime "expires_at"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_jobs_on_client_id"
    t.index ["job_type"], name: "index_jobs_on_job_type"
    t.index ["location"], name: "index_jobs_on_location"
    t.index ["published_at"], name: "index_jobs_on_published_at"
    t.index ["status"], name: "index_jobs_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "type", null: false
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
    t.index ["type"], name: "index_users_on_type"
  end

  add_foreign_key "jobs", "users", column: "client_id"
end
