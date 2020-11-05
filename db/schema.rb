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

ActiveRecord::Schema.define(version: 2020_11_05_051625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :nfl_team, [
    "ari",
    "atl",
    "bal",
    "buf",
    "car",
    "chi",
    "cin",
    "cle",
    "dal",
    "den",
    "det",
    "gb",
    "hou",
    "ind",
    "jax",
    "kc",
    "lac",
    "lar",
    "lv",
    "mia",
    "min",
    "ne",
    "no",
    "nyg",
    "nyj",
    "phi",
    "pit",
    "sea",
    "sf",
    "tb",
    "ten",
    "was",
  ], force: :cascade

  create_enum :player_position, [
    "qb",
    "rb",
    "wr",
    "te",
    "dst",
  ], force: :cascade

  create_table "gameweeks", force: :cascade do |t|
    t.integer "season", null: false
    t.integer "week_number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "player_pool_entries", force: :cascade do |t|
    t.bigint "player_pool_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_player_pool_entries_on_player_id"
    t.index ["player_pool_id"], name: "index_player_pool_entries_on_player_pool_id"
  end

  create_table "player_pools", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameweek_id"], name: "index_player_pools_on_gameweek_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.enum "team", null: false, enum_name: "nfl_team"
    t.enum "opponent", null: false, enum_name: "nfl_team"
    t.enum "position", null: false, enum_name: "player_position"
    t.integer "dk_id", null: false
    t.index ["gameweek_id"], name: "index_players_on_gameweek_id"
  end

  create_table "scheduled_games", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.time "start_time", null: false
    t.string "home_team", null: false
    t.string "road_team", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameweek_id"], name: "index_scheduled_games_on_gameweek_id"
  end

  add_foreign_key "player_pool_entries", "player_pools"
  add_foreign_key "player_pool_entries", "players"
  add_foreign_key "player_pools", "gameweeks"
  add_foreign_key "players", "gameweeks"
  add_foreign_key "scheduled_games", "gameweeks"
end
