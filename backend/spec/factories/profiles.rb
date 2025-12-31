FactoryBot.define do
  factory :profile do
    name { "山田太郎" }
    birthday { Date.new(1990, 1, 1) }
    gender { :male }
    career_profile { "エンジニアとして10年の経験を持つ。" }
    job_summary { "バックエンドエンジニアとして、Railsアプリケーションの開発に従事。" }
    document_date { Date.current }
  end
end

