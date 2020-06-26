# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_26_042716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "rule", null: false
    t.bigint "first_team_id", null: false
    t.bigint "second_team_id", null: false
    t.bigint "winner_id"
    t.integer "first_team_points", default: 0, null: false
    t.integer "second_team_points", default: 0, null: false
    t.bigint "match_id"
    t.integer "round"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_team_id"], name: "index_games_on_first_team_id"
    t.index ["match_id"], name: "index_games_on_match_id"
    t.index ["second_team_id"], name: "index_games_on_second_team_id"
    t.index ["winner_id"], name: "index_games_on_winner_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "first_team_id", null: false
    t.bigint "second_team_id", null: false
    t.bigint "winner_id"
    t.integer "first_team_points", default: 0
    t.integer "second_team_points", default: 0
    t.integer "rule", null: false
    t.integer "games_rule", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_team_id"], name: "index_matches_on_first_team_id"
    t.index ["second_team_id"], name: "index_matches_on_second_team_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "team_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_team_users_on_team_id"
    t.index ["user_id"], name: "index_team_users_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "login"
    t.string "slug"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "games", "matches"
  add_foreign_key "games", "teams", column: "first_team_id"
  add_foreign_key "games", "teams", column: "second_team_id"
  add_foreign_key "games", "teams", column: "winner_id"
  add_foreign_key "matches", "teams", column: "first_team_id"
  add_foreign_key "matches", "teams", column: "second_team_id"
  add_foreign_key "matches", "teams", column: "winner_id"
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "users"
end
