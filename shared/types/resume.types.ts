/**
 * 共有型定義ファイル
 * バックエンドとフロントエンドで共通の型を定義
 */

// 学歴情報
export interface Education {
  school: string;
  degree: string;
  startDate: string;
  endDate: string;
  details?: string;
}

// 職歴情報
export interface Experience {
  company: string;
  position: string;
  startDate: string;
  endDate: string;
  description?: string;
}

// スキル情報
export interface Skill {
  name: string;
  level?: 'beginner' | 'intermediate' | 'advanced' | 'expert' | string;
}

// 資格情報
export interface Certification {
  name: string;
  date: string;
  issuer?: string;
}

// 履歴書データ型
export interface ResumeData {
  fullName: string;
  email: string;
  phone: string;
  address?: string;
  birthDate: string;
  photo?: string;
  summary?: string;
  education: Education[];
  experience: Experience[];
  skills?: Skill[];
  certifications?: Certification[];
  motivation?: string;
}

// APIレスポンス型
export interface ApiResponse<T = any> {
  success: boolean;
  message?: string;
  data?: T;
  error?: string;
}

// バリデーションエラー型
export interface ValidationError {
  field: string;
  message: string;
}

// PDF生成リクエスト型
export type GeneratePdfRequest = ResumeData;

// PDF生成レスポンス型（Blobまたはバッファ）
export type GeneratePdfResponse = Blob | Buffer;

