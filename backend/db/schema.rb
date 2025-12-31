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

ActiveRecord::Schema[8.1].define(version: 2025_01_01_000008) do
  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "birthday", null: false, comment: "生年月日"
    t.text "career_profile", comment: "キャリアプロフィール"
    t.datetime "created_at", null: false
    t.date "document_date", default: -> { "(curdate())" }, comment: "記入日（職務経歴書の記入日）"
    t.integer "gender", comment: "性別（enum: male, female, other, prefer_not_to_say）"
    t.text "job_summary", comment: "職務要約"
    t.string "name", null: false, comment: "氏名"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_profiles_on_name"
  end

  create_table "skill_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", null: false, comment: "カテゴリコード（例: programming_language, frontend）"
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順序"
    t.boolean "is_active", default: true, null: false, comment: "有効フラグ"
    t.string "name", null: false, comment: "カテゴリ名（例: プログラミング言語、フロントエンド）"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_skill_categories_on_code", unique: true
    t.index ["display_order"], name: "index_skill_categories_on_display_order"
    t.index ["is_active"], name: "index_skill_categories_on_is_active"
  end

  create_table "skills", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name", comment: "表示名（カテゴリ別の分類表示用、例: クラウド、フロントエンド）"
    t.string "name", null: false, comment: "スキル名（例: Rails, AWS, React）"
    t.bigint "skill_category_id", null: false, comment: "スキルカテゴリID"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
    t.index ["skill_category_id", "name"], name: "index_skills_on_skill_category_id_and_name"
    t.index ["skill_category_id"], name: "index_skills_on_skill_category_id"
  end

  create_table "work_experience_skills", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date", comment: "使用終了日（職務経歴内での使用終了日、nullの場合は職務経歴の終了日まで）"
    t.bigint "skill_id", null: false, comment: "スキルID"
    t.date "start_date", null: false, comment: "使用開始日（職務経歴内での使用開始日）"
    t.datetime "updated_at", null: false
    t.text "usage_context", comment: "使用場面・用途（オプション）"
    t.bigint "work_experience_id", null: false, comment: "職務経歴ID"
    t.index ["skill_id"], name: "index_work_experience_skills_on_skill_id"
    t.index ["work_experience_id", "skill_id"], name: "index_work_experience_skills_on_work_exp_and_skill", unique: true
    t.index ["work_experience_id"], name: "index_work_experience_skills_on_work_experience_id"
  end

  create_table "work_experiences", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "achievements", comment: "主な成果・実績"
    t.string "company_name", null: false, comment: "会社名"
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false, comment: "表示順序"
    t.date "end_date", comment: "終了日（nullの場合は在職中）"
    t.text "job_description", comment: "職務内容・担当業務の詳細"
    t.string "position", comment: "役職・職位"
    t.bigint "profile_id", null: false, comment: "プロフィールID"
    t.date "start_date", null: false, comment: "開始日"
    t.text "technical_selection_reason", comment: "技術選定理由"
    t.datetime "updated_at", null: false
    t.index ["profile_id", "display_order"], name: "index_work_experiences_on_profile_id_and_display_order"
    t.index ["profile_id"], name: "index_work_experiences_on_profile_id"
    t.index ["start_date"], name: "index_work_experiences_on_start_date"
  end

  add_foreign_key "skills", "skill_categories"
  add_foreign_key "work_experience_skills", "skills"
  add_foreign_key "work_experience_skills", "work_experiences"
  add_foreign_key "work_experiences", "profiles"
end
