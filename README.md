# 📄 履歴書生成アプリ（TypeScript完全実装版）

プロフェッショナルな履歴書を簡単に作成・PDF出力できるWebアプリケーションです。

**完全TypeScript実装** - 厳格な型安全性とコード品質を保証

## 🚀 技術スタック

### フロントエンド
- **Nuxt.js 3** (Vue 3) - Composition API
- **TypeScript** (strict mode) - 完全型安全
- **Pinia** - 型付き状態管理
- **Axios** - 型安全なHTTP通信

### バックエンド
- **NestJS** - Enterprise-grade Node.jsフレームワーク
- **TypeScript** (strict mode) - 完全型安全
- **PDFKit** - PDF生成
- **class-validator** & **class-transformer** - DTOバリデーション

### 共有型定義
- **shared/types/** - フロントエンド・バックエンド共通の型定義

## 📦 機能

### 基本機能
- ✅ 基本情報の入力（氏名、連絡先、住所など）
- ✅ 学歴の複数追加・編集・削除
- ✅ 職歴の複数追加・編集・削除
- ✅ スキルセットの登録
- ✅ 資格情報の登録
- ✅ 自己PR・志望動機の入力
- ✅ PDF形式でのダウンロード

### 高度な機能
- ✅ **リアルタイムバリデーション** - 入力内容の即時検証
- ✅ **ローカルストレージ保存** - データの永続化
- ✅ **データ読み込み機能** - 保存したデータの復元
- ✅ **型安全なAPI通信** - TypeScriptによる完全な型チェック
- ✅ **エラーハンドリング** - 詳細なエラーメッセージ
- ✅ **レスポンシブデザイン** - あらゆるデバイスで快適
- ✅ **モダンUI** - グラデーションとアニメーション

## 🛠️ セットアップ方法

### 前提条件
- Node.js (v18以上推奨)
- npm または yarn
- TypeScript の基本知識

### 1. バックエンドのセットアップ

```bash
# バックエンドディレクトリに移動
cd backend

# 依存関係のインストール
npm install

# 開発サーバーの起動（ポート3001）
npm run start:dev
```

バックエンドAPI: http://localhost:3001

### 2. フロントエンドのセットアップ

```bash
# フロントエンドディレクトリに移動
cd frontend

# 依存関係のインストール
npm install

# 開発サーバーの起動（ポート3000）
npm run dev
```

フロントエンド: http://localhost:3000

## 📖 使い方

1. **基本情報の入力**
   - 氏名、メールアドレス、電話番号、生年月日を入力（必須）
   - 住所、自己PRは任意で入力

2. **学歴の追加**
   - 「+ 学歴を追加」ボタンで学歴を追加
   - 学校名、学位、期間を入力
   - 複数追加可能

3. **職歴の追加**
   - 「+ 職歴を追加」ボタンで職歴を追加
   - 会社名、役職、期間、業務内容を入力
   - 複数追加可能

4. **スキル・資格の追加**
   - 必要に応じてスキルや資格を追加
   - レベルや発行元も記載可能

5. **志望動機の入力**
   - 志望動機や特記事項を記入

6. **データの保存（オプション）**
   - 「💾 保存」ボタンでローカルストレージに保存
   - 「📂 読み込み」ボタンで保存データを復元

7. **PDF生成**
   - 「📥 PDF生成・ダウンロード」ボタンをクリック
   - バリデーションチェック後、自動的にPDFがダウンロード

## 🏗️ プロジェクト構造

```
resume-builder/
├── shared/                         # 共有型定義
│   └── types/
│       └── resume.types.ts        # 共通型定義
│
├── backend/                        # NestJS バックエンド
│   ├── src/
│   │   ├── main.ts                # エントリーポイント（型安全）
│   │   ├── app.module.ts          # ルートモジュール
│   │   └── resume/
│   │       ├── dto/               # Data Transfer Objects
│   │       │   └── create-resume.dto.ts
│   │       ├── resume.controller.ts    # APIコントローラー（型付き）
│   │       ├── resume.service.ts       # PDF生成サービス（型付き）
│   │       └── resume.module.ts
│   ├── package.json
│   └── tsconfig.json              # TypeScript strict設定
│
├── frontend/                       # Nuxt.js フロントエンド
│   ├── assets/css/                # スタイルシート
│   ├── composables/               # Composable関数（型付き）
│   │   ├── useApi.ts              # API通信（型安全）
│   │   └── useResumeValidator.ts  # バリデーション（型付き）
│   ├── pages/
│   │   └── index.vue              # メインページ（完全型付き）
│   ├── stores/
│   │   └── resume.ts              # Pinia ストア（型付き）
│   ├── types/
│   │   └── api.types.ts           # API型定義
│   ├── app.vue
│   ├── nuxt.config.ts
│   ├── tsconfig.json              # TypeScript strict設定
│   └── package.json
│
└── README.md                       # このファイル
```

## 🔧 API エンドポイント

### POST `/resume/generate`
履歴書データを受け取り、PDF形式で返却します。

**リクエストボディ:** `ResumeData` 型
```typescript
interface ResumeData {
  fullName: string;
  email: string;
  phone: string;
  birthDate: string;
  address?: string;
  summary?: string;
  education: Education[];
  experience: Experience[];
  skills?: Skill[];
  certifications?: Certification[];
  motivation?: string;
}
```

**レスポンス:** PDF ファイル (application/pdf)

### POST `/resume/preview`
履歴書データの検証用エンドポイント

**リクエストボディ:** `ResumeData` 型
**レスポンス:** `ApiResponse<ResumeData>` 型

## 📘 TypeScript の特徴

### 1. 厳格な型チェック
すべてのファイルで `strict: true` を有効化
- `noImplicitAny`: any型の暗黙的使用を禁止
- `strictNullChecks`: null/undefinedの厳密チェック
- `strictFunctionTypes`: 関数型の厳密チェック

### 2. 共有型定義
`shared/types/` ディレクトリでフロントエンド・バックエンド共通の型を定義

### 3. 型安全なAPI通信
- Axiosのレスポンス型を明示的に指定
- エラーハンドリングも型安全

### 4. DTOバリデーション
NestJSの `class-validator` でランタイムバリデーション

### 5. Piniaストアの型付け
- State、Getters、Actionsすべてに型定義
- TypeScriptの恩恵を最大限活用

## 🎨 カスタマイズ

### スタイルの変更
`frontend/assets/css/main.css` でデザインをカスタマイズ

### PDF レイアウトの変更
`backend/src/resume/resume.service.ts` の各メソッドでPDFレイアウトを変更

### バリデーションルールの変更
`frontend/composables/useResumeValidator.ts` でバリデーションロジックを変更

### 型定義の拡張
`shared/types/resume.types.ts` で共通型を拡張

## 🚀 本番環境へのデプロイ

### バックエンド
```bash
cd backend
npm run build
npm run start:prod
```

### フロントエンド
```bash
cd frontend
npm run build
npm run preview
```

## 📝 環境変数

### フロントエンド (.env)
```bash
API_BASE_URL=http://localhost:3001
```

本番環境では適切なAPIのURLに変更してください。

## 🧪 型チェック

### バックエンド
```bash
cd backend
npx tsc --noEmit
```

### フロントエンド
```bash
cd frontend
npx nuxi typecheck
```

## 🔍 コード品質

### Linting
```bash
# バックエンド
cd backend
npm run lint

# フロントエンド
cd frontend
npm run lint
```

## 🎯 TypeScript のメリット

1. **コンパイル時のエラー検出** - 実行前にバグを発見
2. **IDEのインテリセンス** - 快適な開発体験
3. **リファクタリングの安全性** - 大規模な変更も安心
4. **ドキュメントとしての型** - コードが自己文書化
5. **チーム開発の効率化** - 型による契約で意思疎通

## 🤝 貢献

プルリクエストや改善提案を歓迎します！

TypeScriptの型定義の改善提案も大歓迎です。

## 📄 ライセンス

MIT License

## 🙏 謝辞

このプロジェクトは以下の素晴らしいオープンソースプロジェクトを使用しています：
- Nuxt.js
- NestJS
- PDFKit
- Vue.js
- TypeScript
- Pinia

---

**TypeScript完全実装版の特徴:**
- ✅ すべてのコードが型安全
- ✅ strict modeを全ファイルで有効化
- ✅ 共有型定義による一貫性
- ✅ 詳細なJSDoc コメント
- ✅ エラーハンドリングの型付け
- ✅ バリデーション機能の完全型付け

**開発者向けメモ:**
- バックエンドはポート3001で動作
- フロントエンドはポート3000で動作
- CORSは開発環境用に設定済み
- 本番環境では適切なセキュリティ設定を追加してください
- `shared/types/` の型定義を両方のプロジェクトで参照
