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

ActiveRecord::Schema[7.0].define(version: 2022_09_01_040023) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "enemy_id", null: false
    t.boolean "victory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "turn", default: 1
    t.index ["enemy_id"], name: "index_battles_on_enemy_id"
    t.index ["player_id"], name: "index_battles_on_player_id"
  end

  create_table "creatures", force: :cascade do |t|
    t.string "name"
    t.boolean "dead", default: false
    t.integer "lvl", default: 1
    t.integer "max_hp"
    t.integer "hp"
    t.integer "atk"
    t.integer "def"
    t.integer "spd"
    t.integer "dex"
    t.integer "int"
    t.integer "luk"
    t.integer "exp", default: 0
    t.string "hero_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "battles_count", default: 0
    t.integer "victories", default: 0
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_creatures_on_user_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.bigint "creature_id", null: false
    t.bigint "item_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creature_id"], name: "index_equipment_on_creature_id"
    t.index ["item_id"], name: "index_equipment_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "hp"
    t.integer "atk"
    t.integer "def"
    t.integer "spd"
    t.integer "dex"
    t.integer "int"
    t.integer "luk"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "battles", "creatures", column: "enemy_id"
  add_foreign_key "battles", "creatures", column: "player_id"
  add_foreign_key "creatures", "users"
  add_foreign_key "equipment", "creatures"
  add_foreign_key "equipment", "items"
end
