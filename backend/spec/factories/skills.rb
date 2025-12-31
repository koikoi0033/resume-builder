FactoryBot.define do
  factory :skill do
    association :skill_category
    name { "Ruby" }
    display_name { nil }

    trait :frontend do
      association :skill_category, :frontend
      name { "React" }
    end

    trait :backend do
      association :skill_category, :backend
      name { "Rails" }
    end

    trait :database do
      association :skill_category, :database
      name { "PostgreSQL" }
    end

    trait :infra do
      association :skill_category, :infra
      name { "AWS" }
    end

    trait :tool do
      association :skill_category, :tool
      name { "Docker" }
    end

    trait :os do
      association :skill_category, :os
      name { "Linux" }
    end

    trait :with_display_name do
      display_name { "カスタム表示名" }
    end
  end
end


