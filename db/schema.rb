# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150817193135) do

  create_table "champion_matches", force: :cascade do |t|
    t.integer  "summoner_id"
    t.integer  "champion_id"
    t.integer  "match_id"
    t.string   "region"
    t.string   "season"
    t.string   "version"
    t.integer  "duration"
    t.string   "tier"
    t.string   "division"
    t.string   "lane"
    t.string   "role"
    t.boolean  "winner"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "assists"
    t.integer  "tower_kills"
    t.integer  "inhibitor_kills"
    t.integer  "wards_placed"
    t.integer  "wards_killed"
    t.boolean  "first_blood_kill"
    t.boolean  "first_blood_assist"
    t.decimal  "xp_per_min_0_10"
    t.decimal  "xp_per_min_10_20"
    t.decimal  "xp_per_min_20_30"
    t.decimal  "xp_per_min_30_end"
    t.decimal  "xp_diff_0_10"
    t.decimal  "xp_diff_10_20"
    t.decimal  "xp_diff_20_30"
    t.decimal  "xp_diff_30_end"
    t.decimal  "cs_per_min_0_10"
    t.decimal  "cs_per_min_10_20"
    t.decimal  "cs_per_min_20_30"
    t.decimal  "cs_per_min_30_end"
    t.decimal  "cs_diff_0_10"
    t.decimal  "cs_diff_10_20"
    t.decimal  "cs_diff_20_30"
    t.decimal  "cs_diff_30_end"
    t.decimal  "gold_per_min_0_10"
    t.decimal  "gold_per_min_10_20"
    t.decimal  "gold_per_min_20_30"
    t.decimal  "gold_per_min_30_end"
    t.decimal  "damage_taken_diff_0_10"
    t.decimal  "damage_taken_diff_10_20"
    t.decimal  "damage_taken_diff_20_30"
    t.decimal  "damage_taken_diff_30_end"
    t.integer  "total_damage_dealt_champs"
    t.integer  "total_damage_taken"
    t.integer  "total_cs"
    t.integer  "monsters_enemy_jungle"
    t.integer  "monsters_team_jungle"
    t.integer  "team_dragon_kills"
    t.integer  "team_baron_kills"
    t.integer  "team_tower_kills"
    t.integer  "team_inhibitor_kills"
    t.integer  "team_kills"
    t.integer  "team_deaths"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "champion_matches", ["champion_id"], name: "index_champion_matches_on_champion_id"
  add_index "champion_matches", ["lane"], name: "index_champion_matches_on_lane"
  add_index "champion_matches", ["match_id"], name: "index_champion_matches_on_match_id"
  add_index "champion_matches", ["region"], name: "index_champion_matches_on_region"
  add_index "champion_matches", ["role"], name: "index_champion_matches_on_role"
  add_index "champion_matches", ["season"], name: "index_champion_matches_on_season"
  add_index "champion_matches", ["summoner_id"], name: "index_champion_matches_on_summoner_id"
  add_index "champion_matches", ["tier"], name: "index_champion_matches_on_tier"
  add_index "champion_matches", ["version"], name: "index_champion_matches_on_version"
  add_index "champion_matches", ["winner"], name: "index_champion_matches_on_winner"

  create_table "champions", force: :cascade do |t|
    t.string   "name"
    t.integer  "champion_id"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "champions", ["champion_id"], name: "index_champions_on_champion_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "matches", force: :cascade do |t|
    t.integer  "match_id"
    t.string   "region"
    t.boolean  "processed",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "matches", ["match_id"], name: "index_matches_on_match_id"
  add_index "matches", ["processed"], name: "index_matches_on_processed"
  add_index "matches", ["region"], name: "index_matches_on_region"

  create_table "summoners", force: :cascade do |t|
    t.integer  "summoner_id"
    t.string   "summoner_name"
    t.datetime "last_checked"
    t.string   "region"
    t.string   "tier"
    t.string   "division"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "summoners", ["summoner_id"], name: "index_summoners_on_summoner_id"
  add_index "summoners", ["summoner_name"], name: "index_summoners_on_summoner_name"
  add_index "summoners", ["tier"], name: "index_summoners_on_tier"

end
