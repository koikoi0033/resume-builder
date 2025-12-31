# TypeScript 実装ガイド

このプロジェクトは完全にTypeScriptで実装されており、厳格な型安全性を提供します。

## 📚 目次

1. [プロジェクト構成](#プロジェクト構成)
2. [型定義](#型定義)
3. [共有モジュール](#共有モジュール)
4. [TypeScript設定](#typescript設定)
5. [型チェック](#型チェック)
6. [ベストプラクティス](#ベストプラクティス)

## プロジェクト構成

```
resume-builder/
├── shared/                         # 共有モジュール
│   ├── types/                      # 型定義
│   │   ├── resume.types.ts        # 履歴書の型
│   │   ├── utility.types.ts       # ユーティリティ型
│   │   └── index.ts               # エクスポート
│   ├── utils/                      # ユーティリティ関数
│   │   ├── date.utils.ts          # 日付関連
│   │   ├── string.utils.ts        # 文字列関連
│   │   ├── validation.utils.ts    # バリデーション
│   │   └── index.ts
│   ├── constants/                  # 定数
│   │   ├── resume.constants.ts
│   │   └── index.ts
│   └── index.ts                    # メインエクスポート
├── backend/                        # NestJS (TypeScript)
└── frontend/                       # Nuxt.js (TypeScript)
```

## 型定義

### 基本型

```typescript
// 履歴書データ
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

// 学歴
interface Education {
  school: string;
  degree: string;
  startDate: string;
  endDate: string;
  details?: string;
}

// 職歴
interface Experience {
  company: string;
  position: string;
  startDate: string;
  endDate: string;
  description?: string;
}
```

### ユーティリティ型

```typescript
// Nullable型
type Nullable<T> = T | null;

// Optional型
type Optional<T> = T | undefined;

// DeepPartial型
type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

// Result型（成功 or エラー）
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };
```

## 共有モジュール

### インポート方法

#### バックエンド
```typescript
import type { ResumeData, Education } from '@shared/types/resume.types';
import { formatDate, calculateAge } from '@shared/utils/date.utils';
import { SKILL_LEVELS } from '@shared/constants/resume.constants';
```

#### フロントエンド
```typescript
import type { ResumeData, Education } from '@shared/types/resume.types';
import { formatDate, calculateAge } from '@shared/utils/date.utils';
import { SKILL_LEVELS } from '@shared/constants/resume.constants';
```

### パスエイリアス設定

#### tsconfig.json（共通）
```json
{
  "compilerOptions": {
    "paths": {
      "@shared/*": ["../shared/*"]
    }
  }
}
```

## TypeScript設定

### 厳格モード

両プロジェクトで以下の厳格な設定を使用：

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### バックエンド固有設定

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2021",
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true
  }
}
```

### フロントエンド固有設定

```json
{
  "compilerOptions": {
    "moduleResolution": "bundler",
    "jsx": "preserve"
  }
}
```

## 型チェック

### バックエンド

```bash
cd backend
npm run typecheck
```

または

```bash
npx tsc --noEmit
```

### フロントエンド

```bash
cd frontend
npm run typecheck
```

または

```bash
npx nuxi typecheck
```

## ベストプラクティス

### 1. 明示的な型注釈

```typescript
// ❌ 悪い例
const generatePDF = async (data) => {
  // ...
};

// ✅ 良い例
const generatePDF = async (data: ResumeData): Promise<Buffer> => {
  // ...
};
```

### 2. 型ガード

```typescript
// 型ガードの使用
const isEducation = (item: Education | Experience): item is Education => {
  return 'school' in item;
};

if (isEducation(item)) {
  console.log(item.school); // 型安全
}
```

### 3. ジェネリクス

```typescript
// ジェネリック関数
const apiCall = async <T>(endpoint: string): Promise<T> => {
  const response = await fetch(endpoint);
  return response.json() as T;
};

// 使用例
const data = await apiCall<ResumeData>('/api/resume');
```

### 4. 非nullアサーション演算子の回避

```typescript
// ❌ 悪い例
const name = user.name!; // 危険

// ✅ 良い例
const name = user.name ?? 'Unknown';
```

### 5. 型のナローイング

```typescript
// 型のナローイング
const processValue = (value: string | number) => {
  if (typeof value === 'string') {
    return value.toUpperCase(); // string型
  } else {
    return value.toFixed(2); // number型
  }
};
```

### 6. Readonly修飾子

```typescript
// 不変オブジェクト
interface Config {
  readonly apiUrl: string;
  readonly timeout: number;
}

const config: Readonly<Config> = {
  apiUrl: 'http://localhost:3001',
  timeout: 5000,
};

// config.apiUrl = 'new-url'; // エラー
```

### 7. ユニオン型とリテラル型

```typescript
// リテラル型のユニオン
type Status = 'pending' | 'processing' | 'completed' | 'failed';

const updateStatus = (status: Status) => {
  // status は4つの値のいずれか
};
```

### 8. 型エイリアスとインターフェース

```typescript
// 型エイリアス（ユニオン、プリミティブなど）
type ID = string | number;
type Point = { x: number; y: number };

// インターフェース（オブジェクト、拡張可能）
interface User {
  id: ID;
  name: string;
}

interface Admin extends User {
  role: string;
}
```

## エディター設定

### VSCode推奨設定

`.vscode/settings.json`:

```json
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.preferences.importModuleSpecifier": "relative"
}
```

### VSCode推奨拡張機能

- TypeScript Vue Plugin (Volar)
- ESLint
- Prettier

## トラブルシューティング

### 型エラーの解決

1. **型が見つからない**
   ```bash
   npm install --save-dev @types/node
   ```

2. **パスエイリアスが解決できない**
   - `tsconfig.json` のパス設定を確認
   - IDE/エディターを再起動

3. **strictモードエラー**
   - `null` や `undefined` のチェックを追加
   - Optional Chaining (`?.`) の使用

## まとめ

このプロジェクトは、TypeScriptの強力な型システムを最大限活用し、以下を実現しています：

- ✅ コンパイル時のエラー検出
- ✅ IDEの強力なインテリセンス
- ✅ リファクタリングの安全性
- ✅ ドキュメントとしての型定義
- ✅ フロントエンド・バックエンド間の型の整合性

TypeScriptの恩恵を受けながら、安全で保守性の高いコードを書くことができます！

