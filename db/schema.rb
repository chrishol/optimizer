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

ActiveRecord::Schema.define(version: 2021_09_09_001808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :game_venue, [
    "home",
    "road",
    "neutral",
  ], force: :cascade

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

  create_enum :slate_type, [
    "cash",
    "gpp",
  ], force: :cascade

  create_table "entered_lineups", force: :cascade do |t|
    t.bigint "results_set_id", null: false
    t.integer "slate_rank", null: false
    t.string "entry_name", null: false
    t.decimal "points", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "entry_id", null: false
    t.index ["results_set_id"], name: "index_entered_lineups_on_results_set_id"
  end

  create_table "entered_lineups_players", id: false, force: :cascade do |t|
    t.bigint "entered_lineup_id", null: false
    t.bigint "player_id", null: false
    t.index ["entered_lineup_id"], name: "index_entered_lineups_players_on_entered_lineup_id"
    t.index ["player_id"], name: "index_entered_lineups_players_on_player_id"
  end

  create_table "game_lines", force: :cascade do |t|
    t.bigint "scheduled_game_id", null: false
    t.string "site_name"
    t.decimal "home_total", precision: 5, scale: 2, null: false
    t.decimal "road_total", precision: 5, scale: 2, null: false
    t.decimal "game_total", precision: 5, scale: 2, null: false
    t.decimal "home_spread", precision: 5, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["scheduled_game_id"], name: "index_game_lines_on_scheduled_game_id"
  end

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
    t.boolean "is_locked", default: false
    t.boolean "is_excluded", default: false
    t.index ["player_id"], name: "index_player_pool_entries_on_player_id"
    t.index ["player_pool_id"], name: "index_player_pool_entries_on_player_pool_id"
  end

  create_table "player_pools", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameweek_id"], name: "index_player_pools_on_gameweek_id"
  end

  create_table "player_results", force: :cascade do |t|
    t.bigint "results_set_id", null: false
    t.bigint "player_id", null: false
    t.decimal "ownership", precision: 5, scale: 2, default: "0.0"
    t.decimal "points", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_player_results_on_player_id"
    t.index ["results_set_id"], name: "index_player_results_on_results_set_id"
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
    t.enum "game_venue", default: "neutral", null: false, enum_name: "game_venue"
    t.integer "previous_price"
    t.index ["gameweek_id"], name: "index_players_on_gameweek_id"
  end

  create_table "projection_sets", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.string "source", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameweek_id"], name: "index_projection_sets_on_gameweek_id"
  end

  create_table "projections", force: :cascade do |t|
    t.bigint "projection_set_id", null: false
    t.bigint "player_id", null: false
    t.decimal "projection", precision: 5, scale: 2, default: "0.0"
    t.decimal "projected_value", precision: 5, scale: 2, default: "0.0"
    t.decimal "projected_ownership", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "projected_ceiling", precision: 5, scale: 2, default: "0.0"
    t.index ["player_id"], name: "index_projections_on_player_id"
    t.index ["projection_set_id"], name: "index_projections_on_projection_set_id"
  end

  create_table "results_sets", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.string "slate_name", null: false
    t.enum "slate_type", null: false, enum_name: "slate_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameweek_id"], name: "index_results_sets_on_gameweek_id"
  end

  create_table "scheduled_games", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.datetime "start_time", null: false
    t.enum "home_team", null: false, enum_name: "nfl_team"
    t.enum "road_team", null: false, enum_name: "nfl_team"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameweek_id"], name: "index_scheduled_games_on_gameweek_id"
  end

  create_table "team_rankings", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.string "team_name"
    t.integer "off_dvoa_rank"
    t.integer "off_pass_dvoa_rank"
    t.integer "off_rush_dvoa_rank"
    t.integer "def_dvoa_rank"
    t.integer "def_pass_dvoa_rank"
    t.integer "def_rush_dvoa_rank"
    t.integer "etr_ol_rank"
    t.integer "etr_dl_rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "elo_rating"
    t.integer "elo_rank"
    t.index ["gameweek_id"], name: "index_team_rankings_on_gameweek_id"
  end

  add_foreign_key "entered_lineups", "results_sets"
  add_foreign_key "entered_lineups_players", "entered_lineups"
  add_foreign_key "entered_lineups_players", "players"
  add_foreign_key "game_lines", "scheduled_games"
  add_foreign_key "player_pool_entries", "player_pools"
  add_foreign_key "player_pool_entries", "players"
  add_foreign_key "player_pools", "gameweeks"
  add_foreign_key "player_results", "players"
  add_foreign_key "player_results", "results_sets"
  add_foreign_key "players", "gameweeks"
  add_foreign_key "projection_sets", "gameweeks"
  add_foreign_key "projections", "players"
  add_foreign_key "projections", "projection_sets"
  add_foreign_key "results_sets", "gameweeks"
  add_foreign_key "scheduled_games", "gameweeks"
  add_foreign_key "team_rankings", "gameweeks"
end
