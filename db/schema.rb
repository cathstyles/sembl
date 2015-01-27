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

ActiveRecord::Schema.define(version: 20150126221244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

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
    t.string   "title",                                                    null: false
    t.text     "description"
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "invite_only",              default: false
    t.boolean  "uploads_allowed",          default: false
    t.string   "theme"
    t.boolean  "allow_keyword_search",     default: false
    t.string   "state"
    t.integer  "current_round",            default: 1
    t.integer  "random_seed"
    t.integer  "number_of_players"
    t.json     "filter_content_by"
    t.boolean  "stale",                    default: false
    t.datetime "state_changed_at",         default: '2014-10-16 04:51:12', null: false
    t.integer  "reminder_count_for_state", default: 0,                     null: false
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
    t.integer  "x",               default: 0, null: false
    t.integer  "y",               default: 0, null: false
  end

  create_table "placements", force: true do |t|
    t.string   "state",      null: false
    t.integer  "thing_id"
    t.integer  "node_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.float    "score"
  end

  add_index "placements", ["creator_id"], name: "index_placements_on_creator_id", using: :btree

  create_table "players", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.float    "score",                    default: 0.0,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                                    null: false
    t.string   "email"
    t.string   "move_state"
    t.datetime "state_changed_at",         default: '2014-10-16 04:51:31', null: false
    t.integer  "reminder_count_for_state", default: 0,                     null: false
  end

  create_table "profiles", force: true do |t|
    t.integer "user_id"
    t.string  "name"
    t.text    "bio"
    t.string  "avatar"
  end

  create_table "que_jobs", id: false, force: true do |t|
    t.integer  "priority",    limit: 2, default: 100,                                        null: false
    t.datetime "run_at",                default: "now()",                                    null: false
    t.integer  "job_id",      limit: 8, default: "nextval('que_jobs_job_id_seq'::regclass)", null: false
    t.text     "job_class",                                                                  null: false
    t.json     "args",                  default: [],                                         null: false
    t.integer  "error_count",           default: 0,                                          null: false
    t.text     "last_error"
    t.text     "queue",                 default: "",                                         null: false
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
    t.text     "description",        null: false
    t.string   "state",              null: false
    t.float    "score"
    t.integer  "link_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_id"
    t.integer  "target_id"
    t.text     "source_description"
    t.text     "target_description"
  end

  add_index "resemblances", ["creator_id"], name: "index_resemblances_on_creator_id", using: :btree
  add_index "resemblances", ["link_id"], name: "index_resemblances_on_link_id", using: :btree
  add_index "resemblances", ["source_id"], name: "index_resemblances_on_source_id", using: :btree
  add_index "resemblances", ["target_id"], name: "index_resemblances_on_target_id", using: :btree

  create_table "things", force: true do |t|
    t.string   "title"
    t.text     "description",        default: ""
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "attribution"
    t.string   "item_url"
    t.string   "copyright"
    t.json     "general_attributes", default: {},    null: false
    t.string   "import_row_id"
    t.string   "access_via"
    t.integer  "random_seed"
    t.boolean  "suggested_seed",     default: false
    t.integer  "game_id"
    t.boolean  "sensitive",          default: false
    t.boolean  "mature",             default: false
    t.boolean  "moderator_approved"
    t.string   "dates"
    t.string   "keywords"
    t.string   "places"
    t.string   "node_type"
  end

  add_index "things", ["creator_id"], name: "index_things_on_creator_id", using: :btree
  add_index "things", ["game_id"], name: "index_things_on_game_id", using: :btree
  add_index "things", ["updator_id"], name: "index_things_on_updator_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                   default: 1,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
