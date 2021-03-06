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

ActiveRecord::Schema.define(version: 2019_02_10_183049) do

  create_table "issues", force: :cascade do |t|
    t.boolean "assigned"
    t.text "description"
    t.string "repo_name"
    t.string "title"
    t.string "url", default: ""
    t.string "user_avatar_url", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_labels_on_name", unique: true
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_languages_on_name"
  end

  create_table "tags", force: :cascade do |t|
    t.integer "issue_id"
    t.integer "label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_tags_on_issue_id"
    t.index ["label_id"], name: "index_tags_on_label_id"
  end

end
