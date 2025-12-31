FactoryBot.define do
  factory :work_experience do
    association :profile
    company_name { "株式会社サンプル" }
    position { "エンジニア" }
    start_date { Date.new(2020, 4, 1) }
    end_date { Date.new(2023, 3, 31) }
    job_description { "Railsアプリケーションの開発・保守" }
    achievements { "ユーザー数10万人を達成" }
    technical_selection_reason { "スケーラビリティを考慮してRailsを選択" }
    display_order { 0 }

    trait :current do
      end_date { nil }
    end
  end
end

