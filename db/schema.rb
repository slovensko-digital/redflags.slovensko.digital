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

ActiveRecord::Schema.define(version: 20171030115814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "published_revision_id"
    t.bigint "latest_revision_id"
  end

  create_table "project_revision_ratings", force: :cascade do |t|
    t.bigint "project_revision_id", null: false
    t.bigint "rating_type_id", null: false
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_revision_id"], name: "index_project_revision_ratings_on_project_revision_id"
    t.index ["rating_type_id"], name: "index_project_revision_ratings_on_rating_type_id"
  end

  create_table "project_revisions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "revision_id", null: false
    t.string "title", null: false
    t.string "full_name"
    t.string "guarantor"
    t.string "description"
    t.string "budget"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body_html"
    t.index ["project_id"], name: "index_project_revisions_on_project_id"
    t.index ["revision_id"], name: "index_project_revisions_on_revision_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_projects_on_page_id"
  end

  create_table "que_jobs", primary_key: ["queue", "priority", "run_at", "job_id"], force: :cascade, comment: "3" do |t|
    t.integer "priority", limit: 2, default: 100, null: false
    t.datetime "run_at", default: -> { "now()" }, null: false
    t.bigserial "job_id", null: false
    t.text "job_class", null: false
    t.json "args", default: [], null: false
    t.integer "error_count", default: 0, null: false
    t.text "last_error"
    t.text "queue", default: "", null: false
  end

  create_table "rating_phases", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rating_types", force: :cascade do |t|
    t.bigint "rating_phase_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rating_phase_id"], name: "index_rating_types_on_rating_phase_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.integer "version", null: false
    t.jsonb "raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.index ["page_id", "version"], name: "index_revisions_on_page_id_and_version", unique: true
    t.index ["page_id"], name: "index_revisions_on_page_id"
  end

  add_foreign_key "pages", "revisions", column: "latest_revision_id"
  add_foreign_key "pages", "revisions", column: "published_revision_id"
  add_foreign_key "project_revision_ratings", "project_revisions"
  add_foreign_key "project_revision_ratings", "rating_types"
  add_foreign_key "project_revisions", "projects"
  add_foreign_key "project_revisions", "revisions"
  add_foreign_key "projects", "pages"
  add_foreign_key "rating_types", "rating_phases"
  add_foreign_key "revisions", "pages"
end
