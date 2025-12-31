class WorkExperience < ApplicationRecord
  belongs_to :profile
  has_many :work_experience_skills, dependent: :destroy
  has_many :skills, through: :work_experience_skills

  validates :company_name, presence: true
  validates :start_date, presence: true
  validate :end_date_after_start_date
  validate :dates_within_reasonable_range

  scope :ordered, -> { order(display_order: :asc, start_date: :desc) }
  scope :current, -> { where(end_date: nil) }
  scope :past, -> { where.not(end_date: nil) }

  # 在職中かどうか
  def current?
    end_date.nil?
  end

  # 期間の月数を計算
  # 返り値: Integer（月数）
  #
  # 使用例:
  #   we = WorkExperience.find(1)
  #   months = we.duration_months
  #   # => 24
  #
  #   # フロントエンドで年数と月数に変換する例:
  #   years = months / 12
  #   remaining_months = months % 12
  #   # => years: 2, remaining_months: 0
  def duration_months
    end_date_value = end_date || Date.current
    ((end_date_value.year - start_date.year) * 12) + (end_date_value.month - start_date.month) + 1
  end

  # 期間を年数と月数で取得
  # 返り値: { total_months: Integer, years: Integer, months: Integer }
  #
  # 使用例:
  #   we = WorkExperience.find(1)
  #   duration = we.duration_years_and_months
  #   # => { total_months: 24, years: 2, months: 0 }
  #
  #   # フロントエンドでの使用例:
  #   puts "#{duration[:years]}年#{duration[:months]}ヶ月"
  #   # または月数のみで表示する場合
  #   puts "#{duration[:total_months]}ヶ月"
  def duration_years_and_months
    months = duration_months
    {
      total_months: months,
      years: months / 12,
      months: months % 12
    }
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "は開始日より後である必要があります") if end_date < start_date
  end

  def dates_within_reasonable_range
    return unless start_date

    if start_date > Date.current
      errors.add(:start_date, "は未来の日付にできません")
    end

    return unless end_date

    if end_date > Date.current
      errors.add(:end_date, "は未来の日付にできません")
    end
  end
end

