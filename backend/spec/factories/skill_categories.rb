FactoryBot.define do
  factory :skill_category do
    name { "プログラミング言語" }
    code { "programming_language" }
    display_order { 1 }
    is_active { true }

    trait :frontend do
      name { "フロントエンド" }
      code { "frontend" }
      display_order { 2 }
    end

    trait :backend do
      name { "バックエンド" }
      code { "backend" }
      display_order { 3 }
    end

    trait :database do
      name { "データベース" }
      code { "database" }
      display_order { 4 }
    end

    trait :infra do
      name { "インフラ・クラウド" }
      code { "infra" }
      display_order { 5 }
    end

    trait :tool do
      name { "ツール" }
      code { "tool" }
      display_order { 6 }
    end

    trait :os do
      name { "OS" }
      code { "os" }
      display_order { 7 }
    end

    trait :inactive do
      is_active { false }
    end
  end
end

