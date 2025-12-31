import { z } from "zod";

// ============================================================================
// Enum型定義
// ============================================================================

/**
 * 性別のenum
 */
export enum Gender {
  MALE = 0,
  FEMALE = 1,
  OTHER = 2,
  PREFER_NOT_TO_SAY = 3,
}

/**
 * 性別の表示名
 */
export const GenderLabels: Record<Gender, string> = {
  [Gender.MALE]: "男性",
  [Gender.FEMALE]: "女性",
  [Gender.OTHER]: "その他",
  [Gender.PREFER_NOT_TO_SAY]: "回答しない",
};

// ============================================================================
// 基本型定義
// ============================================================================

/**
 * スキルカテゴリ
 */
export interface SkillCategory {
  id: number;
  name: string;
  code: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

/**
 * スキル
 */
export interface Skill {
  id: number;
  skill_category_id: number;
  name: string;
  display_name: string | null;
  created_at: string;
  updated_at: string;
  skill_category?: SkillCategory;
}

/**
 * 職務経歴スキル（中間テーブル）
 */
export interface WorkExperienceSkill {
  id: number;
  work_experience_id: number;
  skill_id: number;
  start_date: string; // YYYY-MM-DD形式
  end_date: string | null; // YYYY-MM-DD形式、nullの場合は職務経歴の終了日まで
  usage_context: string | null;
  created_at: string;
  updated_at: string;
  skill?: Skill;
  work_experience?: WorkExperience;
}

/**
 * 職務経歴
 */
export interface WorkExperience {
  id: number;
  profile_id: number;
  company_name: string;
  position: string | null;
  start_date: string; // YYYY-MM-DD形式
  end_date: string | null; // YYYY-MM-DD形式、nullの場合は在職中
  job_description: string | null;
  achievements: string | null;
  technical_selection_reason: string | null;
  display_order: number;
  created_at: string;
  updated_at: string;
  work_experience_skills?: WorkExperienceSkill[];
  skills?: Skill[];
}

/**
 * プロフィール（職務経歴書のメインデータ）
 */
export interface Profile {
  id: number;
  name: string;
  birthday: string; // YYYY-MM-DD形式
  gender: Gender | null;
  career_profile: string | null;
  job_summary: string | null;
  document_date: string; // YYYY-MM-DD形式
  created_at: string;
  updated_at: string;
  work_experiences?: WorkExperience[];
}

// ============================================================================
// Zodスキーマ定義（react-hook-form用）
// ============================================================================

/**
 * 性別のzodスキーマ
 */
export const genderSchema = z.nativeEnum(Gender).nullable();

/**
 * 日付文字列のバリデーション（YYYY-MM-DD形式）
 */
const dateStringSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, "日付はYYYY-MM-DD形式で入力してください")
  .refine(
    (date) => {
      const d = new Date(date);
      return d instanceof Date && !isNaN(d.getTime());
    },
    { message: "有効な日付を入力してください" }
  );

/**
 * 過去または現在の日付のバリデーション
 */
const pastOrCurrentDateSchema = dateStringSchema.refine(
  (date) => {
    const d = new Date(date);
    const today = new Date();
    today.setHours(23, 59, 59, 999); // 今日の終わりまで
    return d <= today;
  },
  { message: "未来の日付は入力できません" }
);

/**
 * スキルカテゴリのzodスキーマ
 */
export const skillCategorySchema = z.object({
  id: z.number().int().positive(),
  name: z.string().min(1, "カテゴリ名は必須です"),
  code: z.string().min(1, "カテゴリコードは必須です"),
  display_order: z.number().int().min(0),
  is_active: z.boolean(),
  created_at: z.string(),
  updated_at: z.string(),
});

/**
 * スキルのzodスキーマ
 */
export const skillSchema = z.object({
  id: z.number().int().positive().optional(),
  skill_category_id: z.number().int().positive("スキルカテゴリは必須です"),
  name: z.string().min(1, "スキル名は必須です"),
  display_name: z.string().nullable().optional(),
  created_at: z.string().optional(),
  updated_at: z.string().optional(),
});

/**
 * 職務経歴スキルのzodスキーマ
 */
export const workExperienceSkillSchema = z
  .object({
    id: z.number().int().positive().optional(),
    work_experience_id: z.number().int().positive().optional(),
    skill_id: z.number().int().positive("スキルは必須です"),
    start_date: pastOrCurrentDateSchema,
    end_date: dateStringSchema.nullable().optional(),
    usage_context: z.string().nullable().optional(),
    created_at: z.string().optional(),
    updated_at: z.string().optional(),
  })
  .refine(
    (data) => {
      if (!data.end_date) return true;
      const start = new Date(data.start_date);
      const end = new Date(data.end_date);
      return end >= start;
    },
    {
      message: "使用終了日は使用開始日以降である必要があります",
      path: ["end_date"],
    }
  );

/**
 * 職務経歴のzodスキーマ
 */
export const workExperienceSchema = z
  .object({
    id: z.number().int().positive().optional(),
    profile_id: z.number().int().positive().optional(),
    company_name: z.string().min(1, "会社名は必須です"),
    position: z.string().nullable().optional(),
    start_date: pastOrCurrentDateSchema,
    end_date: dateStringSchema.nullable().optional(),
    job_description: z.string().nullable().optional(),
    achievements: z.string().nullable().optional(),
    technical_selection_reason: z.string().nullable().optional(),
    display_order: z.number().int().min(0).default(0),
    created_at: z.string().optional(),
    updated_at: z.string().optional(),
    work_experience_skills: z.array(workExperienceSkillSchema).optional(),
  })
  .refine(
    (data) => {
      if (!data.end_date) return true;
      const start = new Date(data.start_date);
      const end = new Date(data.end_date);
      return end >= start;
    },
    {
      message: "終了日は開始日以降である必要があります",
      path: ["end_date"],
    }
  )
  .refine(
    (data) => {
      if (!data.work_experience_skills || data.work_experience_skills.length === 0) {
        return true;
      }
      const start = new Date(data.start_date);
      const end = data.end_date ? new Date(data.end_date) : new Date();
      
      return data.work_experience_skills.every((skill) => {
        const skillStart = new Date(skill.start_date);
        const skillEnd = skill.end_date ? new Date(skill.end_date) : end;
        
        // スキルの使用期間が職務経歴の期間内にあるかチェック
        return skillStart >= start && skillStart <= end && skillEnd <= end && skillEnd >= skillStart;
      });
    },
    {
      message: "スキルの使用期間は職務経歴の期間内である必要があります",
      path: ["work_experience_skills"],
    }
  );

/**
 * プロフィールのzodスキーマ
 */
export const profileSchema = z.object({
  id: z.number().int().positive().optional(),
  name: z.string().min(1, "氏名は必須です"),
  birthday: pastOrCurrentDateSchema,
  gender: genderSchema,
  career_profile: z.string().nullable().optional(),
  job_summary: z.string().nullable().optional(),
  document_date: pastOrCurrentDateSchema.default(() => {
    const today = new Date();
    return `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, "0")}-${String(today.getDate()).padStart(2, "0")}`;
  }),
  created_at: z.string().optional(),
  updated_at: z.string().optional(),
  work_experiences: z.array(workExperienceSchema).optional(),
});

// ============================================================================
// 型推論用のヘルパー型
// ============================================================================

/**
 * Profileのzodスキーマから型を推論
 */
export type ProfileFormData = z.infer<typeof profileSchema>;

/**
 * WorkExperienceのzodスキーマから型を推論
 */
export type WorkExperienceFormData = z.infer<typeof workExperienceSchema>;

/**
 * WorkExperienceSkillのzodスキーマから型を推論
 */
export type WorkExperienceSkillFormData = z.infer<typeof workExperienceSkillSchema>;

/**
 * Skillのzodスキーマから型を推論
 */
export type SkillFormData = z.infer<typeof skillSchema>;

/**
 * SkillCategoryのzodスキーマから型を推論
 */
export type SkillCategoryFormData = z.infer<typeof skillCategorySchema>;

