require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:work_experiences).dependent(:destroy) }
    it { is_expected.to have_many(:work_experience_skills).through(:work_experiences) }
    it { is_expected.to have_many(:skills).through(:work_experience_skills) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:birthday) }
    it { is_expected.to validate_presence_of(:document_date) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:gender).with_values(male: 0, female: 1, other: 2, prefer_not_to_say: 3) }
  end

  describe "callbacks" do
    describe "#set_default_document_date" do
      context "記入日が設定されていない場合" do
        it "記入日を現在日付に設定する" do
          profile = build(:profile, document_date: nil)
          expect(profile.document_date).to be_nil
          profile.valid?
          expect(profile.document_date).to eq(Date.current)
        end
      end

      context "記入日が既に設定されている場合" do
        it "記入日を変更しない" do
          custom_date = Date.new(2024, 1, 1)
          profile = build(:profile, document_date: custom_date)
          profile.valid?
          expect(profile.document_date).to eq(custom_date)
        end
      end
    end
  end

  describe "#skill_experience_summary" do
    let(:profile) { create(:profile) }
    let(:skill1) { create(:skill, name: "Rails") }
    let(:skill2) { create(:skill, name: "React") }

    context "職務経歴がない場合" do
      it "空の配列を返す" do
        expect(profile.skill_experience_summary).to eq([])
      end
    end

    context "職務経歴とスキルがある場合" do
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
               skill: skill1,
               start_date: Date.new(2020, 1, 1),
               end_date: Date.new(2023, 1, 1))
      end
      let!(:work_experience_skill2) do
        create(:work_experience_skill,
               work_experience: work_experience2,
               skill: skill1,
               start_date: Date.new(2023, 1, 1),
               end_date: Date.new(2024, 1, 1))
      end
      let!(:work_experience_skill3) do
        create(:work_experience_skill,
               work_experience: work_experience1,
               skill: skill2,
               start_date: Date.new(2020, 1, 1),
               end_date: Date.new(2021, 1, 1))
      end

      it "total_months、years、monthsを含むスキル情報を返す" do
        summary = profile.skill_experience_summary

        expect(summary.length).to eq(2)
        expect(summary.first[:skill]).to eq(skill1)
        expect(summary.first[:total_months]).to eq(49) # 36 months + 13 months
        expect(summary.first[:years]).to eq(4)
        expect(summary.first[:months]).to eq(1)

        expect(summary.second[:skill]).to eq(skill2)
        expect(summary.second[:total_months]).to eq(13) # 13 months
        expect(summary.second[:years]).to eq(1)
        expect(summary.second[:months]).to eq(1)
      end

      it "total_monthsの降順でソートする" do
        summary = profile.skill_experience_summary
        expect(summary.first[:total_months]).to be >= summary.second[:total_months]
      end
    end

    context "職務経歴が在職中（終了日がnil）の場合" do
      let!(:work_experience) do
        create(:work_experience,
               profile: profile,
               start_date: 12.months.ago.to_date,
               end_date: nil)
      end
      let!(:work_experience_skill) do
        create(:work_experience_skill,
               work_experience: work_experience,
               skill: skill1,
               start_date: 12.months.ago.to_date,
               end_date: nil)
      end

      it "現在日付までの月数を計算する" do
        summary = profile.skill_experience_summary
        expect(summary.first[:total_months]).to be >= 12
      end
    end
  end
end

