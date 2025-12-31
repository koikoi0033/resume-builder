# Shared Types

フロントエンドとバックエンドで共有する型定義

## 使用方法

### バックエンド
```typescript
import type { ResumeData, Education, Experience } from '@shared/types/resume.types';
```

### フロントエンド
```typescript
import type { ResumeData, Education, Experience } from '@shared/types/resume.types';
```

## 型定義ファイル

- `resume.types.ts` - 履歴書関連の型定義

## TypeScript設定

両プロジェクトの `tsconfig.json` で以下のパスエイリアスを設定：

```json
{
  "compilerOptions": {
    "paths": {
      "@shared/*": ["../shared/*"]
    }
  }
}
```

