class WorkExperienceSkill < ApplicationRecord
  belongs_to :work_experience
  belongs_to :skill

  validates :start_date, presence: true
  validate :dates_within_work_experience_period
  validate :end_date_after_start_date

  # 使用期間の月数を計算
  # 返り値: Integer（月数）
  #
  # 使用例:
  #   wes = WorkExperienceSkill.find(1)
  #   months = wes.usage_months
  #   # => 12
  #
  #   # フロントエンドで年数と月数に変換する例:
  #   years = months / 12
  #   remaining_months = months % 12
  #   # => years: 1, remaining_months: 0
  def usage_months
    end_date_value = end_date || work_experience.end_date || Date.current
    ((end_date_value.year - start_date.year) * 12) + (end_date_value.month - start_date.month) + 1
  end

  private

  def dates_within_work_experience_period
    return unless work_experience && start_date

    we = work_experience
    we_end_date = we.end_date || Date.current

    if start_date < we.start_date
      errors.add(:start_date, "は職務経歴の開始日（#{we.start_date}）以降である必要があります")
    end

    if start_date > we_end_date
      errors.add(:start_date, "は職務経歴の終了日（#{we_end_date}）以前である必要があります")
    end

    return unless end_date

    if end_date > we_end_date
      errors.add(:end_date, "は職務経歴の終了日（#{we_end_date}）以前である必要があります")
    end
  end

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "は開始日より後である必要があります") if end_date < start_date
  end
end

