FactoryBot.define do
  factory :work_experience_skill do
    association :work_experience
    association :skill
    start_date { work_experience.start_date }
    end_date { work_experience.end_date }
    usage_context { nil }

    trait :current do
      end_date { nil }
    end

    trait :with_usage_context do
      usage_context { "API開発で使用" }
    end
  end
end

