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

ActiveRecord::Schema.define(version: 2020_10_24_204037) do

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

  create_table "players", force: :cascade do |t|
    t.bigint "gameweek_id", null: false
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.enum "team", enum_name: "nfl_team"
    t.enum "opponent", enum_name: "nfl_team"
    t.enum "position", enum_name: "player_position"
    t.index ["gameweek_id"], name: "index_players_on_gameweek_id"
  end

  add_foreign_key "players", "gameweeks"
end
