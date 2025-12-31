/**
 * ユーティリティ型定義
 * 汎用的な型ヘルパー
 */

// Nullable型
export type Nullable<T> = T | null;

// Optional型
export type Optional<T> = T | undefined;

// DeepPartial型 - ネストされたオブジェクトを部分的に
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

// DeepReadonly型 - ネストされたオブジェクトを読み取り専用に
export type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object ? DeepReadonly<T[P]> : T[P];
};

// Required型の拡張 - ネストされたオブジェクトも必須に
export type DeepRequired<T> = {
  [P in keyof T]-?: T[P] extends object ? DeepRequired<T[P]> : T[P];
};

// ID型
export type ID = string | number;

// Timestamp型
export type Timestamp = string | Date | number;

// Status型
export type Status = 'pending' | 'processing' | 'completed' | 'failed';

// Result型（成功 or エラー）
export type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

// Pagination型
export interface Pagination {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

// PaginatedResponse型
export interface PaginatedResponse<T> {
  data: T[];
  pagination: Pagination;
}

// Sort型
export interface Sort {
  field: string;
  order: 'asc' | 'desc';
}

// Filter型
export interface Filter {
  field: string;
  operator: 'eq' | 'ne' | 'gt' | 'gte' | 'lt' | 'lte' | 'like' | 'in';
  value: any;
}

