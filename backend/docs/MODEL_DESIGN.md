# データモデル設計書

## 概要

本ドキュメントは、職務経歴書生成アプリケーションのデータモデル設計を説明します。
要件定義に基づき、JIS規格の項目を網羅しつつ、**スキルと経歴の自動連動**を実現するDRYな設計となっています。

## モデル構造

```
Profile (プロフィール)
  ├── WorkExperience (職務経歴)
  │     └── WorkExperienceSkill (中間テーブル)
  │           └── Skill (スキルマスタ)
  └── (Profile → WorkExperienceSkill → Skill の関連でスキル経験年数を自動計算)
```

## 各モデルの詳細

### 1. Profile（プロフィール）

**目的**: 基本情報とテキストセクションを管理

**主要カラム**:
- `name`: 氏名
- `birthday`: 生年月日
- `gender`: 性別（enum: male, female, other, prefer_not_to_say）
- `career_profile`: キャリアプロフィール
- `job_summary`: 職務要約
- `document_date`: 記入日（職務経歴書の記入日、デフォルトは現在日付）

**特徴**:
- `skill_experience_summary` メソッドで、全スキルの合計経験期間を自動計算（月数、年数、月数をすべて含む）
- 職務経歴に紐付いた使用技術から、テクニカルスキル欄の「経験年数」を自動算出（DRY原則）

### 2. WorkExperience（職務経歴）

**目的**: 各職務経歴の詳細情報を管理

**主要カラム**:
- `profile_id`: プロフィールID（外部キー）
- `company_name`: 会社名
- `position`: 役職・職位
- `start_date`: 開始日
- `end_date`: 終了日（nullの場合は在職中）
- `job_description`: 職務内容・担当業務の詳細
- `achievements`: 主な成果・実績
- `technical_selection_reason`: 技術選定理由
- `display_order`: 表示順序

**特徴**:
- `duration_months` メソッドで期間の月数を取得
- `duration_years_and_months` メソッドで期間を月数、年数、月数で取得
- 日付の妥当性検証（開始日 < 終了日、未来日付の禁止）
- **項目表示制御**: フロントエンド側で制御することを推奨（柔軟性が高い）

### 3. Skill（スキルマスタ）

**目的**: スキルのマスタデータを管理

**主要カラム**:
- `category`: カテゴリ（enum: programming_language, frontend, backend, database, infra, tool, os）
- `name`: スキル名（例: Rails, AWS, React）
- `display_name`: 表示名（カテゴリ別の分類表示用、オプション）

**特徴**:
- `category_display_name` メソッドでカテゴリの日本語表示名を取得
- `total_experience_for_profile` メソッドで特定プロフィールでの合計経験月数を計算
- `experience_years_and_months_for_profile` メソッドで経験期間を月数、年数、月数で取得
- インクリメンタルサーチ対応のため、`name`にユニークインデックス

### 4. WorkExperienceSkill（中間テーブル）

**目的**: 職務経歴とスキルの関連、および各職務経歴内での使用期間を記録

**主要カラム**:
- `work_experience_id`: 職務経歴ID（外部キー）
- `skill_id`: スキルID（外部キー）
- `start_date`: 使用開始日（職務経歴内での使用開始日）
- `end_date`: 使用終了日（職務経歴内での使用終了日、nullの場合は職務経歴の終了日まで）
- `usage_context`: 使用場面・用途（オプション）

**特徴**:
- `usage_months` メソッドで使用期間の月数を取得
- 職務経歴の期間内であることを検証
- 同一職務経歴内で同じスキルを重複登録できない（ユニーク制約）

## スキル経験年数の自動計算ロジック

### 計算方法

1. **各職務経歴での使用期間を集計**
   - `WorkExperienceSkill` の `start_date` と `end_date`（または職務経歴の終了日）から月数を計算
   - 複数の職務経歴で同じスキルを使用している場合、期間を合算

2. **重複期間の考慮**
   - 現在の実装では、複数の職務経歴で重複する期間があっても単純合算
   - 兼業や個人事業主の掛け持ちなど、同時期に複数の職務で同じスキルを使用している場合を想定
   - 将来的に重複期間を除外する機能を追加可能（例: `DateRange` クラスを使用）

3. **返り値の設計方針**
   - メソッドは月数、年数、月数をすべて含む形式で返す
   - フロントエンドで柔軟に表示形式を選択可能（例：「2年3ヶ月」「27ヶ月」「2.25年」など）
   - 月数も含めることで、異なる表示形式に対応しやすい

### 使用例

各モデルのメソッドに使用例を記載しています。詳細は各モデルファイルを参照してください。

## JIS規格への対応

### 職務経歴書の必須項目

- ✅ **基本情報**: `Profile` モデルで管理（氏名、生年月日）
- ✅ **記入日**: `Profile.document_date` で管理
- ✅ **職務経歴**: `WorkExperience` モデルで管理（会社名、期間、職務内容）
- ✅ **スキル**: `Skill` と `WorkExperienceSkill` で管理（種類、使用期間）

### 出力レイアウトへの対応

- **ヘッダー**: `Profile.name`, `Profile.document_date` を使用
- **キャリアプロフィール**: `Profile.career_profile` を使用
- **職務要約**: `Profile.job_summary` を使用
- **テクニカルスキル**: `Profile.skill_experience_summary` を使用（自動計算された経験年数）

## DRY原則の実現

### 1. 経験年数の自動計算

- 手動で経験年数を入力・更新する必要がない
- 職務経歴を更新すると、自動的にスキルの経験年数が再計算される

### 2. 期間計算の一元化

- `WorkExperience#duration_months`
- `WorkExperienceSkill#usage_months`
- `Profile#skill_experience_summary`

これらのメソッドで期間計算ロジックを一元化

### 3. バリデーションの統一

- 日付の妥当性検証を各モデルで実装
- 未来日付の禁止、開始日 < 終了日の検証を統一

## API設計の考え方

### サーバーサイドとフロントエンドの責務分担

#### サーバーサイド（Rails）で持つべきもの

1. **データの整合性とビジネスロジック**
   - 期間計算のロジック（月数の計算）
   - バリデーション（日付の妥当性など）
   - データの関連性（リレーション）

2. **期間データの提供**
   - 期間は月数、年数、月数をすべて含む形式で返す
   - 理由: フロントエンドで柔軟に表示形式を選択可能
     - 「2年3ヶ月」（年数と月数を使用）
     - 「27ヶ月」（月数のみを使用）
     - 「2.25年」（月数を12で割って計算）
     - 「約2年」（年数のみを使用）

3. **よく使う形式の提供**
   - 月数、年数、月数をすべて含めることで、フロントエンドでの変換処理を簡素化
   - サーバーサイドで責務を担うことで、一貫性のあるデータ提供が可能

#### フロントエンド（React）で持つべきもの

1. **表示形式の制御**
   - 月数を年数と月数に変換して表示
   - ロケール（言語・地域）に応じた表示形式
   - UI要件に応じた表示形式の切り替え

2. **項目の表示/非表示制御**
   - `WorkExperience` の各項目（`job_description`, `achievements`, `technical_selection_reason` など）の表示制御
   - 理由: 柔軟性が高く、UI要件の変更に対応しやすい

3. **フォーマット処理**
   - 日付のフォーマット（例: "2025年1月1日" vs "2025/01/01"）
   - 数値のフォーマット（例: カンマ区切りなど）

### 設計のメリット

1. **変更への対応が容易**
   - 表示形式の変更はフロントエンド側のみで対応可能
   - サーバーサイドのAPIを変更する必要がない

2. **再利用性が高い**
   - 同じAPIを異なるUI（Web、モバイル、PDF出力など）で利用可能
   - 各UIで最適な表示形式を選択できる

3. **テストが容易**
   - サーバーサイドは数値計算のテストに集中できる
   - フロントエンドは表示ロジックのテストに集中できる

### 実装例

```ruby
# サーバーサイド（Rails）
profile.skill_experience_summary
# => [
#   { skill: #<Skill name: "Rails">, total_months: 36, years: 3, months: 0 },
#   ...
# ]
```

```typescript
// フロントエンド（React/TypeScript）
// 年数と月数で表示
const formatYearsAndMonths = (item: { years: number; months: number }) => {
  return `${item.years}年${item.months}ヶ月`;
};

// 月数のみで表示
const formatMonths = (totalMonths: number) => {
  return `${totalMonths}ヶ月`;
};

// 年数のみで表示（小数点あり）
const formatYears = (totalMonths: number) => {
  return `${(totalMonths / 12).toFixed(1)}年`;
};
```

## 今後の拡張可能性

### 1. 重複期間の除外

複数の職務経歴で同じスキルを使用している場合、重複期間を除外して実経験年数を計算

### 2. スキルレベルの追加

`WorkExperienceSkill` に `level` カラムを追加し、各職務経歴でのスキルレベルを記録

### 3. 資格情報の追加

`Certification` モデルを追加し、資格情報を管理

### 4. 学歴情報の追加

`Education` モデルを追加し、学歴情報を管理

### 5. AI生成履歴の管理

`career_profile` や `job_summary` のAI生成履歴を `AiGenerationHistory` モデルで管理

## マイグレーション実行方法

```bash
cd backend
rails db:migrate
```

## 注意事項

- マイグレーションファイルのタイムスタンプ（`20250101000001` など）は、実際の作成日時に合わせて調整してください
- データベースがMySQLの場合は、PostgreSQL固有の機能（例: `CURRENT_DATE`）を使用していないため、そのまま使用可能です
- ただし、要件定義ではPostgreSQLと記載されているため、必要に応じて `database.yml` を確認してください

