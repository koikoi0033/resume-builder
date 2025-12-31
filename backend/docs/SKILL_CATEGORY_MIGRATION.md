# スキルカテゴリのマスタ化について

## 概要

`Skill`モデルの`category`カラムをenumからマスタテーブル（`SkillCategory`）に変更しました。
これにより、ユーザーがカテゴリをカスタマイズできるようになります。

## 変更内容

### 1. 新しいモデル: SkillCategory

- `name`: カテゴリ名（例: "プログラミング言語"）
- `code`: カテゴリコード（例: "programming_language"）
- `display_order`: 表示順序
- `is_active`: 有効フラグ

### 2. Skillモデルの変更

- `category`（enum）→ `skill_category_id`（外部キー）に変更
- `belongs_to :skill_category`を追加
- `category_display_name`メソッドを更新（skill_categoryのnameを使用）

### 3. マイグレーションの実行順序

マイグレーションは以下の順序で実行されます：

1. `20250101000005_create_skill_categories.rb` - skill_categoriesテーブル作成
2. `20250101000006_create_initial_skill_categories.rb` - 初期データ作成
3. `20250101000008_change_skills_category_to_skill_category.rb` - skillsテーブルの変更とデータ移行

**注意**: タイムスタンプの順序により、実際の実行順序は上記の順番になります。

## 初期データ

以下の7つのカテゴリが初期データとして作成されます：

1. プログラミング言語 (programming_language)
2. フロントエンド (frontend)
3. バックエンド (backend)
4. データベース (database)
5. インフラ・クラウド (infra)
6. ツール (tool)
7. OS (os)

## 使用方法

### カテゴリの追加

```ruby
SkillCategory.create!(
  name: "モバイル",
  code: "mobile",
  display_order: 8,
  is_active: true
)
```

### カテゴリの取得

```ruby
# コードから取得（キャッシュあり）
category = SkillCategory.find_by_code("programming_language")

# 有効なカテゴリのみ取得
active_categories = SkillCategory.active.ordered

# スキルからカテゴリ名を取得
skill.category_display_name # => "プログラミング言語" または skill.display_name
```

### スキルの作成

```ruby
category = SkillCategory.find_by_code("programming_language")
Skill.create!(
  name: "Ruby",
  skill_category: category
)
```

## データ移行について

既存の`category`（enum）の値は、`change_skills_category_to_skill_category`マイグレーションで自動的に`skill_category_id`に変換されます。

## 制約

- スキルが存在するカテゴリは削除できません（`dependent: :restrict_with_error`）
- カテゴリコードはユニークです
- スキル名はユニークです

## 今後の拡張可能性

- カテゴリごとの設定（色、アイコンなど）
- カテゴリの階層化
- カテゴリの多言語対応

