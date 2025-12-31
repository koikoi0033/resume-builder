require "rails_helper"

RSpec.describe Skill, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:skill_category) }
    it { is_expected.to have_many(:work_experience_skills).dependent(:destroy) }
    it { is_expected.to have_many(:work_experiences).through(:work_experience_skills) }
    it { is_expected.to have_many(:profiles).through(:work_experiences) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:skill_category_id) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "#category_display_name" do
    context "表示名が設定されている場合" do
      it "表示名を返す" do
        skill = build(:skill, display_name: "カスタム表示名")
        expect(skill.category_display_name).to eq("カスタム表示名")
      end
    end

    context "表示名がnilの場合" do
      it "スキルカテゴリの名前を返す" do
        skill_category = create(:skill_category, name: "プログラミング言語")
        skill = build(:skill, skill_category: skill_category, display_name: nil)
        expect(skill.category_display_name).to eq("プログラミング言語")
      end
    end

    context "スキルカテゴリがnilの場合" do
      it "空文字列を返す" do
        skill = build(:skill, skill_category: nil, display_name: nil)
        expect(skill.category_display_name).to eq("")
      end
    end
  end

  describe "#total_experience_for_profile" do
    let(:profile) { create(:profile) }
    let(:skill) { create(:skill, name: "Rails") }
    let!(:work_experience1) do
      create(:work_experience,
             profile: profile,
             start_date: Date.new(2020, 1, 1),
             end_date: Date.new(2023, 1, 1))
    end
    let!(:work_experience2) do
      create(:work_experience,
             profile: profile,
             start_date: Date.new(2023, 1, 1),
             end_date: Date.new(2024, 1, 1))
    end
    let!(:work_experience_skill1) do
      create(:work_experience_skill,
             work_experience: work_experience1,
             skill: skill,
             start_date: Date.new(2020, 1, 1),
             end_date: Date.new(2023, 1, 1))
    end
    let!(:work_experience_skill2) do
      create(:work_experience_skill,
             work_experience: work_experience2,
             skill: skill,
             start_date: Date.new(2023, 1, 1),
             end_date: Date.new(2024, 1, 1))
    end

    it "すべての職務経歴にわたる合計月数を計算する" do
      total_months = skill.total_experience_for_profile(profile)
      expect(total_months).to eq(49) # 36 months + 13 months
    end

    context "このスキルを持つ職務経歴がない場合" do
      let(:other_profile) { create(:profile) }

      it "0を返す" do
        expect(skill.total_experience_for_profile(other_profile)).to eq(0)
      end
    end
  end

  describe "#experience_years_and_months_for_profile" do
    let(:profile) { create(:profile) }
    let(:skill) { create(:skill, name: "Rails") }
    let!(:work_experience) do
      create(:work_experience,
             profile: profile,
             start_date: Date.new(2020, 1, 1),
             end_date: Date.new(2023, 1, 1))
    end
    let!(:work_experience_skill) do
      create(:work_experience_skill,
             work_experience: work_experience,
             skill: skill,
             start_date: Date.new(2020, 1, 1),
             end_date: Date.new(2023, 1, 1))
    end

    it "total_months、years、monthsを返す" do
      result = skill.experience_years_and_months_for_profile(profile)

      expect(result[:total_months]).to eq(37) # 36 months + 1
      expect(result[:years]).to eq(3)
      expect(result[:months]).to eq(1)
    end
  end
end

