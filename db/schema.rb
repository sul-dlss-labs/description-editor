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

ActiveRecord::Schema[7.0].define(version: 2022_05_20_124929) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "descriptions", force: :cascade do |t|
    t.string "external_identifier", null: false
    t.jsonb "title", null: false
    t.jsonb "contributor"
    t.jsonb "event"
    t.jsonb "form"
    t.jsonb "geographic"
    t.jsonb "language"
    t.jsonb "note"
    t.jsonb "identifier"
    t.jsonb "subject"
    t.jsonb "access"
    t.jsonb "marcEncodedData"
    t.jsonb "adminMetadata"
    t.string "valueAt"
    t.string "purl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_identifier"], name: "index_descriptions_on_external_identifier", unique: true
  end

  create_table "title_structured_values", force: :cascade do |t|
    t.string "value"
    t.string "type"
    t.bigint "title_id"
    t.index ["title_id"], name: "index_title_structured_values_on_title_id"
  end

  create_table "titles", force: :cascade do |t|
    t.string "value"
    t.boolean "primary_status"
    t.string "type"
    t.bigint "title_id"
    t.index ["title_id"], name: "index_titles_on_title_id"
  end

end
