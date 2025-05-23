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

ActiveRecord::Schema[8.0].define(version: 2025_05_03_194611) do
  create_table "ai_chats", force: :cascade do |t|
    t.string "model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ai_messages", force: :cascade do |t|
    t.integer "chat_id", null: false
    t.integer "tool_call_id"
    t.string "role"
    t.text "content"
    t.string "model_id"
    t.integer "input_tokens"
    t.integer "output_tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_ai_messages_on_chat_id"
    t.index ["tool_call_id"], name: "index_ai_messages_on_tool_call_id"
  end

  create_table "ai_tool_calls", force: :cascade do |t|
    t.integer "message_id", null: false
    t.string "tool_call_id"
    t.string "name"
    t.text "arguments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_ai_tool_calls_on_message_id"
    t.index ["tool_call_id"], name: "index_ai_tool_calls_on_tool_call_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "fullname", null: false
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "birth_year"
    t.integer "death_year"
    t.json "aws_photos"
    t.string "original_fullname"
    t.index ["fullname"], name: "index_authors_on_fullname", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.integer "year_published", null: false
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_title"
    t.string "goodreads_url"
    t.float "goodreads_rating"
    t.integer "goodreads_popularity"
    t.integer "popularity", default: 0
    t.json "aws_covers"
    t.string "wiki_url"
    t.text "summary"
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["title", "author_id"], name: "index_books_on_title_and_author_id", unique: true
    t.index ["year_published"], name: "index_books_on_year_published"
  end

  create_table "tag_connections", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "entity_id", null: false
    t.string "entity_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type", "entity_id", "tag_id"], name: "index_tag_connections_on_entity_type_and_entity_id_and_tag_id", unique: true
    t.index ["tag_id"], name: "index_tag_connections_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0
    t.index ["category"], name: "index_tags_on_category"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "ai_messages", "ai_chats", column: "chat_id"
  add_foreign_key "ai_messages", "ai_tool_calls", column: "tool_call_id"
  add_foreign_key "ai_tool_calls", "ai_messages", column: "message_id"
end
