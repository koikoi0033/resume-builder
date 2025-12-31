class SkillCategory < ApplicationRecord
  has_many :skills, dependent: :restrict_with_error

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :display_order, presence: true

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(display_order: :asc) }

  # カテゴリコードからカテゴリを取得（キャッシュ可能）
  def self.find_by_code(code)
    Rails.cache.fetch("skill_category:#{code}", expires_in: 1.hour) do
      find_by(code: code)
    end
  end
end

