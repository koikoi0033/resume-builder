/**
 * バリデーション関連のユーティリティ関数
 */

import type { ResumeData, Education, Experience } from '../types/resume.types';

/**
 * 必須フィールドのチェック
 */
export const isRequired = (value: any): boolean => {
  if (value === null || value === undefined) return false;
  if (typeof value === 'string') return value.trim().length > 0;
  if (Array.isArray(value)) return value.length > 0;
  return true;
};

/**
 * 最小文字数チェック
 */
export const minLength = (value: string, min: number): boolean => {
  return value.length >= min;
};

/**
 * 最大文字数チェック
 */
export const maxLength = (value: string, max: number): boolean => {
  return value.length <= max;
};

/**
 * 範囲チェック（数値）
 */
export const inRange = (value: number, min: number, max: number): boolean => {
  return value >= min && value <= max;
};

/**
 * パターンマッチング
 */
export const matches = (value: string, pattern: RegExp): boolean => {
  return pattern.test(value);
};

/**
 * 配列に含まれるかチェック
 */
export const isIn = <T>(value: T, array: T[]): boolean => {
  return array.includes(value);
};

/**
 * 学歴データの妥当性チェック
 */
export const isValidEducation = (education: Education): boolean => {
  return !!(
    education.school &&
    education.degree &&
    education.startDate &&
    education.endDate
  );
};

/**
 * 職歴データの妥当性チェック
 */
export const isValidExperience = (experience: Experience): boolean => {
  return !!(
    experience.company &&
    experience.position &&
    experience.startDate &&
    experience.endDate
  );
};

/**
 * 履歴書データの基本的な妥当性チェック
 */
export const isValidResumeData = (data: Partial<ResumeData>): boolean => {
  // 基本情報の必須フィールドチェック
  if (!data.fullName || !data.email || !data.phone || !data.birthDate) {
    return false;
  }

  // 学歴または職歴が必須
  const hasEducation = data.education && data.education.length > 0;
  const hasExperience = data.experience && data.experience.length > 0;
  
  return hasEducation || hasExperience;
};

/**
 * 複数のバリデーション結果を統合
 */
export const combineValidations = (...validations: boolean[]): boolean => {
  return validations.every((v) => v === true);
};

/**
 * カスタムバリデーター型
 */
export type Validator<T> = (value: T) => boolean | string;

/**
 * バリデーターを実行
 */
export const runValidator = <T>(
  value: T,
  validator: Validator<T>
): { valid: boolean; error?: string } => {
  const result = validator(value);
  
  if (typeof result === 'boolean') {
    return { valid: result };
  }
  
  return { valid: false, error: result };
};

/**
 * 複数のバリデーターを実行
 */
export const runValidators = <T>(
  value: T,
  validators: Validator<T>[]
): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];
  
  for (const validator of validators) {
    const result = runValidator(value, validator);
    if (!result.valid && result.error) {
      errors.push(result.error);
    }
  }
  
  return {
    valid: errors.length === 0,
    errors,
  };
};

