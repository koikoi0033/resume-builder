# 📄 職務経歴書作成ツール（resume-builder）

技術者向けの職務経歴書作成ツールです。Rails（バックエンド）とReact（フロントエンド）で構成されたモノレポプロジェクトです。

## 🚀 技術スタック

### フロントエンド
- **React** (TypeScript)
- **Vite** - ビルドツール
- **TypeScript** - 型安全な開発

### バックエンド
- **Ruby on Rails 8.1** - Webフレームワーク
- **MySQL** - データベース
- **RSpec** - テストフレームワーク

### 共有コード
- **shared/** - フロントエンド・バックエンド共通の型定義とユーティリティ

## 📦 プロジェクト構造

```
resume-builder/
├── backend/              # Rails バックエンド
│   ├── app/
│   │   ├── models/      # データモデル
│   │   ├── controllers/ # APIコントローラー
│   │   └── ...
│   ├── config/          # Rails設定
│   ├── db/              # マイグレーション
│   └── spec/            # RSpecテスト
│
├── frontend/            # React フロントエンド
│   ├── src/
│   │   ├── App.tsx
│   │   └── ...
│   └── ...
│
└── shared/              # 共有コード
    ├── types/           # 共通型定義
    ├── constants/       # 共通定数
    └── utils/           # 共通ユーティリティ
```

## 🛠️ セットアップ方法

### 前提条件
- Ruby 3.3以上
- Node.js 18以上
- MySQL 8.0以上

### 1. リポジトリのクローン

```bash
git clone https://github.com/koikoi0033/resume-builder.git
cd resume-builder
```

### 2. バックエンドのセットアップ

```bash
cd backend

# 依存関係のインストール
bundle install

# データベースのセットアップ
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# 開発サーバーの起動（ポート3000）
bin/rails server
```

### 3. フロントエンドのセットアップ

```bash
cd frontend

# 依存関係のインストール
npm install

# 開発サーバーの起動（ポート5173）
npm run dev
```

### 4. 共有コードのビルド（必要な場合）

```bash
# ルートディレクトリで
npm install
```

## 📖 使い方

1. バックエンドサーバーを起動（`backend/` ディレクトリで `bin/rails server`）
2. フロントエンドサーバーを起動（`frontend/` ディレクトリで `npm run dev`）
3. ブラウザで `http://localhost:5173` にアクセス

## 🧪 テスト

### バックエンドのテスト

```bash
cd backend
bundle exec rspec
```

### フロントエンドのテスト

```bash
cd frontend
npm test
```

## 📝 データモデル

### Profile（プロフィール）
- 基本情報（氏名、生年月日、性別など）
- キャリアプロフィール
- 職務要約

### WorkExperience（職務経歴）
- 会社名、役職
- 開始日、終了日
- 業務内容

### Skill（スキル）
- スキル名
- カテゴリ（SkillCategory）

### SkillCategory（スキルカテゴリ）
- カテゴリ名、コード
- 表示順序

## 🔧 開発

### コードスタイル

- **Ruby**: RuboCopを使用
- **TypeScript**: ESLintを使用

### マイグレーション

```bash
cd backend
bin/rails generate migration MigrationName
bin/rails db:migrate
```

## 📄 ライセンス

MIT License
