class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.integer :category, null: false, comment: "カテゴリ（enum: programming_language, frontend, backend, database, infra, tool, os）"
      t.string :name, null: false, comment: "スキル名（例: Rails, AWS, React）"
      t.string :display_name, comment: "表示名（カテゴリ別の分類表示用、例: クラウド、フロントエンド）"

      t.timestamps
    end

    add_index :skills, :category
    add_index :skills, :name, unique: true
    add_index :skills, [:category, :name]
  end
end

