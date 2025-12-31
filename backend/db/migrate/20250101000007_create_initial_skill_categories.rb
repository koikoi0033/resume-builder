class CreateInitialSkillCategories < ActiveRecord::Migration[8.1]
  def up
    # 初期カテゴリデータを作成
    # 注意: このマイグレーションは create_skill_categories の後に実行されることを前提とする
    categories = [
      { name: "プログラミング言語", code: "programming_language", display_order: 1, is_active: true },
      { name: "フロントエンド", code: "frontend", display_order: 2, is_active: true },
      { name: "バックエンド", code: "backend", display_order: 3, is_active: true },
      { name: "データベース", code: "database", display_order: 4, is_active: true },
      { name: "インフラ・クラウド", code: "infra", display_order: 5, is_active: true },
      { name: "ツール", code: "tool", display_order: 6, is_active: true },
      { name: "OS", code: "os", display_order: 7, is_active: true }
    ]

    categories.each do |cat|
      SkillCategory.create!(cat)
    end
  end

  def down
    SkillCategory.where(code: %w[programming_language frontend backend database infra tool os]).destroy_all
  end
end

