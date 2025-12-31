class Skill < ApplicationRecord
  belongs_to :skill_category
  has_many :work_experience_skills, dependent: :destroy
  has_many :work_experiences, through: :work_experience_skills
  has_many :profiles, through: :work_experiences

  validates :name, presence: true, uniqueness: true
  validates :skill_category_id, presence: true

  # カテゴリ別の表示名を取得
  # スキルのdisplay_nameが設定されている場合はそれを優先し、
  # なければskill_categoryのnameを使用
  def category_display_name
    return display_name if display_name.present?

    skill_category&.name || ""
  end

  # 特定のプロフィールでの合計経験月数を計算
  # 返り値: Integer（合計月数）
  #
  # 使用例:
  #   skill = Skill.find_by(name: "Rails")
  #   profile = Profile.find(1)
  #   total_months = skill.total_experience_for_profile(profile)
  #   # => 36
  #
  #   # フロントエンドで年数と月数に変換する例:
  #   years = total_months / 12
  #   months = total_months % 12
  #   # => years: 3, months: 0
  def total_experience_for_profile(profile)
    work_experience_skills
      .joins(:work_experience)
      .where(work_experiences: { profile_id: profile.id })
      .sum do |wes|
        end_date = wes.end_date || wes.work_experience.end_date || Date.current
        start_date = wes.start_date
        ((end_date.year - start_date.year) * 12) + (end_date.month - start_date.month) + 1
      end
  end

  # 特定のプロフィールでの経験期間を年数と月数で取得
  # 返り値: { total_months: Integer, years: Integer, months: Integer }
  #
  # 使用例:
  #   skill = Skill.find_by(name: "Rails")
  #   profile = Profile.find(1)
  #   experience = skill.experience_years_and_months_for_profile(profile)
  #   # => { total_months: 36, years: 3, months: 0 }
  #
  #   # フロントエンドでの使用例:
  #   puts "#{experience[:years]}年#{experience[:months]}ヶ月"
  #   # または月数のみで表示する場合
  #   puts "#{experience[:total_months]}ヶ月"
  def experience_years_and_months_for_profile(profile)
    total_months = total_experience_for_profile(profile)
    {
      total_months: total_months,
      years: total_months / 12,
      months: total_months % 12
    }
  end
end

