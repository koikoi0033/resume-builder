class Profile < ApplicationRecord
  has_many :work_experiences, dependent: :destroy
  has_many :work_experience_skills, through: :work_experiences
  has_many :skills, through: :work_experience_skills

  enum gender: {
    male: 0,
    female: 1,
    other: 2,
    prefer_not_to_say: 3
  }

  validates :name, presence: true
  validates :birthday, presence: true
  validates :document_date, presence: true

  # 記入日のデフォルト値を現在日付に設定
  before_validation :set_default_document_date, on: :create

  # スキルの合計経験期間を自動計算（DRY原則に基づく）
  # 返り値: [{ skill: Skill, total_months: Integer, years: Integer, months: Integer }, ...] （経験月数の降順でソート）
  #
  # 使用例:
  #   profile = Profile.find(1)
  #   summary = profile.skill_experience_summary
  #   # => [
  #   #   { skill: #<Skill name: "Rails">, total_months: 36, years: 3, months: 0 },
  #   #   { skill: #<Skill name: "React">, total_months: 24, years: 2, months: 0 },
  #   #   ...
  #   # ]
  #
  #   # フロントエンドでの使用例:
  #   summary.each do |item|
  #     puts "#{item[:skill].name}: #{item[:years]}年#{item[:months]}ヶ月"
  #     # または月数のみで表示する場合
  #     puts "#{item[:skill].name}: #{item[:total_months]}ヶ月"
  #   end
  def skill_experience_summary
    skills_with_experience = skills.distinct.map do |skill|
      total_months = work_experience_skills
        .where(skill: skill)
        .sum do |wes|
          end_date = wes.end_date || work_experiences.find(wes.work_experience_id).end_date || Date.current
          start_date = wes.start_date
          ((end_date.year - start_date.year) * 12) + (end_date.month - start_date.month) + 1
        end

      {
        skill: skill,
        total_months: total_months,
        years: total_months / 12,
        months: total_months % 12
      }
    end

    skills_with_experience.sort_by { |s| -s[:total_months] }
  end

  private

  def set_default_document_date
    self.document_date ||= Date.current
  end
end

