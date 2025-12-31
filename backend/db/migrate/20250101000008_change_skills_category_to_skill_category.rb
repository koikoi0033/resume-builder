class ChangeSkillsCategoryToSkillCategory < ActiveRecord::Migration[8.1]
  def up
    # 一時的なカラムを追加
    add_reference :skills, :skill_category, null: true, foreign_key: true, comment: "スキルカテゴリID"

    # 既存のcategoryカラムからskill_category_idを設定
    # 注意: このマイグレーションは create_initial_skill_categories の後に実行されることを前提とする
    execute <<-SQL
      UPDATE skills
      SET skill_category_id = (
        SELECT id FROM skill_categories
        WHERE code = CASE skills.category
          WHEN 0 THEN 'programming_language'
          WHEN 1 THEN 'frontend'
          WHEN 2 THEN 'backend'
          WHEN 3 THEN 'database'
          WHEN 4 THEN 'infra'
          WHEN 5 THEN 'tool'
          WHEN 6 THEN 'os'
        END
        LIMIT 1
      )
    SQL

    # 古いカラムとインデックスを削除
    remove_index :skills, :category if index_exists?(:skills, :category)
    remove_index :skills, [:category, :name] if index_exists?(:skills, [:category, :name])
    remove_column :skills, :category

    # 新しいインデックスを追加
    add_index :skills, [:skill_category_id, :name]
    
    # skill_category_idをNOT NULLに変更
    change_column_null :skills, :skill_category_id, false
  end

  def down
    # categoryカラムを追加
    add_column :skills, :category, :integer, null: false, comment: "カテゴリ（enum: programming_language, frontend, backend, database, infra, tool, os）"

    # skill_category_idからcategoryを復元
    execute <<-SQL
      UPDATE skills
      SET category = (
        CASE skill_categories.code
          WHEN 'programming_language' THEN 0
          WHEN 'frontend' THEN 1
          WHEN 'backend' THEN 2
          WHEN 'database' THEN 3
          WHEN 'infra' THEN 4
          WHEN 'tool' THEN 5
          WHEN 'os' THEN 6
        END
      )
      FROM skill_categories
      WHERE skills.skill_category_id = skill_categories.id
    SQL

    # インデックスを追加
    add_index :skills, :category
    add_index :skills, [:category, :name]

    # skill_category_idを削除
    remove_index :skills, [:skill_category_id, :name] if index_exists?(:skills, [:skill_category_id, :name])
    remove_foreign_key :skills, :skill_categories
    remove_reference :skills, :skill_category
  end
end

