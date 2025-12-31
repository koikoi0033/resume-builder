class CreateSkillCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :skill_categories do |t|
      t.string :name, null: false, comment: "カテゴリ名（例: プログラミング言語、フロントエンド）"
      t.string :code, null: false, comment: "カテゴリコード（例: programming_language, frontend）"
      t.integer :display_order, default: 0, null: false, comment: "表示順序"
      t.boolean :is_active, default: true, null: false, comment: "有効フラグ"

      t.timestamps
    end

    add_index :skill_categories, :code, unique: true
    add_index :skill_categories, :display_order
    add_index :skill_categories, :is_active
  end
end

