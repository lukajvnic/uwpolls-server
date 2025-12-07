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

ActiveRecord::Schema[8.0].define(version: 2025_12_07_030616) do
  create_table "polls", force: :cascade do |t|
    t.string "email"
    t.string "title"
    t.string "opt1"
    t.string "opt2"
    t.string "opt3"
    t.string "opt4"
    t.integer "res1", default: 0
    t.integer "res2", default: 0
    t.integer "res3", default: 0
    t.integer "res4", default: 0
    t.integer "totalvotes", default: 0
    t.datetime "timeposted", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "voted_emails", default: ""
    t.text "user_votes", default: "{}"
    t.boolean "allow_peek_results", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "google_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
  end
end
