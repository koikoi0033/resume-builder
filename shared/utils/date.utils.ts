/**
 * 日付関連のユーティリティ関数
 */

/**
 * 日付を YYYY-MM-DD 形式にフォーマット
 */
export const formatDate = (date: Date | string | number): string => {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

/**
 * 日付を日本語形式にフォーマット（YYYY年MM月DD日）
 */
export const formatDateJapanese = (date: Date | string | number): string => {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = d.getMonth() + 1;
  const day = d.getDate();
  return `${year}年${month}月${day}日`;
};

/**
 * 年齢を計算
 */
export const calculateAge = (birthDate: Date | string): number => {
  const today = new Date();
  const birth = new Date(birthDate);
  let age = today.getFullYear() - birth.getFullYear();
  const monthDiff = today.getMonth() - birth.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
    age--;
  }
  
  return age;
};

/**
 * 期間を計算（年数）
 */
export const calculateYearsBetween = (
  startDate: Date | string,
  endDate: Date | string
): number => {
  const start = new Date(startDate);
  const end = new Date(endDate);
  const years = end.getFullYear() - start.getFullYear();
  const monthDiff = end.getMonth() - start.getMonth();
  
  return monthDiff < 0 ? years - 1 : years;
};

/**
 * 今日の日付を取得
 */
export const getToday = (): string => {
  return formatDate(new Date());
};

/**
 * 日付の妥当性チェック
 */
export const isValidDate = (date: string | Date): boolean => {
  const d = new Date(date);
  return d instanceof Date && !isNaN(d.getTime());
};

/**
 * 日付が過去かチェック
 */
export const isPastDate = (date: string | Date): boolean => {
  const d = new Date(date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return d < today;
};

/**
 * 日付が未来かチェック
 */
export const isFutureDate = (date: string | Date): boolean => {
  const d = new Date(date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return d > today;
};

