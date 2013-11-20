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

ActiveRecord::Schema.define(version: 20131120045237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: true do |t|
    t.string   "title",                                      null: false
    t.integer  "number_of_players",                          null: false
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "nodes_attributes",  default: [{"round"=>0}], null: false
    t.json     "links_attributes",  default: [],             null: false
  end

  add_index "boards", ["creator_id"], name: "index_boards_on_creator_id", using: :btree
  add_index "boards", ["updator_id"], name: "index_boards_on_updator_id", using: :btree

  create_table "games", force: true do |t|
    t.integer  "board_id"
    t.string   "title",                                  null: false
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invite_only",          default: false
    t.boolean  "uploads_allowed",      default: false
    t.string   "theme"
    t.text     "filter_content_by"
    t.boolean  "allow_keyword_search", default: false
    t.string   "state",                default: "draft"
    t.integer  "current_round",        default: 1
  end

  add_index "games", ["creator_id"], name: "index_games_on_creator_id", using: :btree
  add_index "games", ["updator_id"], name: "index_games_on_updator_id", using: :btree

  create_table "links", force: true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["game_id"], name: "index_links_on_game_id", using: :btree
  add_index "links", ["source_id"], name: "index_links_on_source_id", using: :btree
  add_index "links", ["target_id"], name: "index_links_on_target_id", using: :btree

  create_table "nodes", force: true do |t|
    t.integer  "game_id"
    t.integer  "round"
    t.string   "state"
    t.integer  "allocated_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "placements", force: true do |t|
    t.string   "state",      null: false
    t.integer  "thing_id"
    t.integer  "node_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "placements", ["creator_id"], name: "index_placements_on_creator_id", using: :btree

  create_table "players", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      default: "completing_turn"
  end

  create_table "ratings", force: true do |t|
    t.float    "rating"
    t.integer  "resemblance_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["creator_id"], name: "index_ratings_on_creator_id", using: :btree
  add_index "ratings", ["resemblance_id"], name: "index_ratings_on_resemblance_id", using: :btree

  create_table "resemblances", force: true do |t|
    t.text     "description", null: false
    t.string   "state",       null: false
    t.float    "score"
    t.integer  "link_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resemblances", ["creator_id"], name: "index_resemblances_on_creator_id", using: :btree
  add_index "resemblances", ["link_id"], name: "index_resemblances_on_link_id", using: :btree

  create_table "things", force: true do |t|
    t.string   "title"
    t.text     "description", default: ""
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "attribution"
    t.string   "item_url"
    t.string   "copyright"
    t.json     "attributes",  default: [], null: false
  end

  add_index "things", ["creator_id"], name: "index_things_on_creator_id", using: :btree
  add_index "things", ["updator_id"], name: "index_things_on_updator_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
