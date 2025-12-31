/**
 * 履歴書関連の定数定義
 */

// スキルレベル
export const SKILL_LEVELS = {
  BEGINNER: 'beginner',
  INTERMEDIATE: 'intermediate',
  ADVANCED: 'advanced',
  EXPERT: 'expert',
} as const;

export const SKILL_LEVELS_JAPANESE = {
  [SKILL_LEVELS.BEGINNER]: '初級',
  [SKILL_LEVELS.INTERMEDIATE]: '中級',
  [SKILL_LEVELS.ADVANCED]: '上級',
  [SKILL_LEVELS.EXPERT]: '専門家',
} as const;

// スキルレベルの型
export type SkillLevel = typeof SKILL_LEVELS[keyof typeof SKILL_LEVELS];

// 学位種別
export const DEGREE_TYPES = {
  HIGH_SCHOOL: '高等学校卒業',
  ASSOCIATE: '短期大学卒業',
  BACHELOR: '学士（大学卒業）',
  MASTER: '修士（大学院修了）',
  DOCTORATE: '博士（大学院修了）',
  OTHER: 'その他',
} as const;

// バリデーションルール
export const VALIDATION_RULES = {
  FULL_NAME: {
    MIN_LENGTH: 2,
    MAX_LENGTH: 50,
  },
  EMAIL: {
    MAX_LENGTH: 100,
  },
  PHONE: {
    MIN_LENGTH: 10,
    MAX_LENGTH: 15,
  },
  ADDRESS: {
    MAX_LENGTH: 200,
  },
  SUMMARY: {
    MAX_LENGTH: 1000,
  },
  MOTIVATION: {
    MAX_LENGTH: 1000,
  },
  DESCRIPTION: {
    MAX_LENGTH: 500,
  },
} as const;

// PDFオプション
export const PDF_OPTIONS = {
  PAGE_SIZE: 'A4',
  MARGIN: {
    TOP: 50,
    BOTTOM: 50,
    LEFT: 50,
    RIGHT: 50,
  },
  FONT_SIZE: {
    TITLE: 24,
    SECTION: 16,
    NORMAL: 12,
    SMALL: 11,
  },
} as const;

// APIエンドポイント
export const API_ENDPOINTS = {
  GENERATE: '/resume/generate',
  PREVIEW: '/resume/preview',
  HEALTH: '/health',
} as const;

// ローカルストレージキー
export const STORAGE_KEYS = {
  RESUME_DATA: 'resumeData',
  USER_PREFERENCES: 'userPreferences',
} as const;

// エラーメッセージ
export const ERROR_MESSAGES = {
  REQUIRED_FIELD: 'この項目は必須です',
  INVALID_EMAIL: '有効なメールアドレスを入力してください',
  INVALID_PHONE: '有効な電話番号を入力してください',
  INVALID_DATE: '有効な日付を入力してください',
  MIN_LENGTH: (min: number) => `${min}文字以上入力してください`,
  MAX_LENGTH: (max: number) => `${max}文字以内で入力してください`,
  NETWORK_ERROR: 'ネットワークエラーが発生しました',
  SERVER_ERROR: 'サーバーエラーが発生しました',
  PDF_GENERATION_ERROR: 'PDF生成に失敗しました',
} as const;

// 成功メッセージ
export const SUCCESS_MESSAGES = {
  PDF_GENERATED: '履歴書のPDFを生成しました',
  DATA_SAVED: 'データを保存しました',
  DATA_LOADED: 'データを読み込みました',
} as const;

