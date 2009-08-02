# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2009072604003) do

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.integer  "division_id"
    t.string   "abbrev"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.float    "point_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "team_id"
    t.integer  "opponent_id"
    t.date     "date"
    t.boolean  "home"
    t.boolean  "neutral"
    t.string   "opponent"
    t.string   "result"
    t.integer  "score_team"
    t.integer  "score_opponent"
    t.string   "location"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer  "conference_id"
    t.string   "ncaa_id"
    t.string   "ncaa_name"
    t.float    "ranking"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end