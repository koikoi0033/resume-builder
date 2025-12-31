require "rails_helper"

RSpec.describe WorkExperienceSkill, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:work_experience) }
    it { is_expected.to belong_to(:skill) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:start_date) }
  end

  describe "#usage_months" do
    let(:work_experience_with_dates) do
      create(:work_experience,
             start_date: Date.new(2020, 1, 1),
             end_date: Date.new(2023, 1, 1))
    end
    let(:work_experience_without_end_date) do
      create(:work_experience,
             start_date: 12.months.ago.to_date,
             end_date: nil)
    end
    let(:subject_with_dates) do
      build(:work_experience_skill,
            work_experience: work_experience_with_dates,
            start_date: Date.new(2020, 1, 1),
            end_date: Date.new(2023, 1, 1))
    end
    let(:subject_without_end_date) do
      build(:work_experience_skill,
            work_experience: work_experience_without_end_date,
            start_date: 12.months.ago.to_date,
            end_date: nil)
    end

    context "使用終了日が設定されている場合" do
      it "使用開始日と使用終了日の間の月数を計算する" do
        work_experience_skill = create(:work_experience_skill,
                                       work_experience: work_experience_with_dates,
                                       start_date: Date.new(2020, 1, 1),
                                       end_date: Date.new(2022, 1, 1))
        expect(work_experience_skill.usage_months).to eq(25) # 24 months + 1
      end
    end

    context "使用終了日がnilで職務経歴に終了日がある場合" do
      it "職務経歴の終了日を使用する" do
        work_experience_skill = create(:work_experience_skill,
                                       work_experience: work_experience_with_dates,
                                       start_date: Date.new(2020, 1, 1),
                                       end_date: nil)
        expect(work_experience_skill.usage_months).to eq(37) # 36 months + 1
      end
    end

    context "使用終了日と職務経歴の終了日が両方nilの場合" do
      it "現在日付までの月数を計算する" do
        work_experience_skill = create(:work_experience_skill,
                                       work_experience: work_experience_without_end_date,
                                       start_date: 12.months.ago.to_date,
                                       end_date: nil)
        expect(work_experience_skill.usage_months).to be >= 12
      end
    end
  end

  describe "validations" do
    describe "#dates_within_work_experience_period" do
      let(:work_experience) do
        create(:work_experience,
               start_date: Date.new(2020, 1, 1),
               end_date: Date.new(2023, 1, 1))
      end

      it "使用開始日が職務経歴の開始日より前の場合、無効" do
        work_experience_skill = build(:work_experience_skill,
                                      work_experience: work_experience,
                                      start_date: Date.new(2019, 1, 1),
                                      end_date: Date.new(2021, 1, 1))
        expect(work_experience_skill).not_to be_valid
        expect(work_experience_skill.errors[:start_date]).to be_present
      end

      it "使用開始日が職務経歴の終了日より後の場合、無効" do
        work_experience_skill = build(:work_experience_skill,
                                      work_experience: work_experience,
                                      start_date: Date.new(2024, 1, 1),
                                      end_date: Date.new(2025, 1, 1))
        expect(work_experience_skill).not_to be_valid
        expect(work_experience_skill.errors[:start_date]).to be_present
      end

      it "使用終了日が職務経歴の終了日より後の場合、無効" do
        work_experience_skill = build(:work_experience_skill,
                                      work_experience: work_experience,
                                      start_date: Date.new(2020, 1, 1),
                                      end_date: Date.new(2024, 1, 1))
        expect(work_experience_skill).not_to be_valid
        expect(work_experience_skill.errors[:end_date]).to be_present
      end

      it "日付が職務経歴の期間内の場合、有効" do
        work_experience_skill = build(:work_experience_skill,
                                      work_experience: work_experience,
                                      start_date: Date.new(2020, 1, 1),
                                      end_date: Date.new(2022, 1, 1))
        expect(work_experience_skill).to be_valid
      end
    end

    describe "#end_date_after_start_date" do
      it "使用終了日が使用開始日より前の場合、無効" do
        work_experience = create(:work_experience)
        work_experience_skill = build(:work_experience_skill,
                                      work_experience: work_experience,
                                      start_date: Date.new(2023, 1, 1),
                                      end_date: Date.new(2022, 1, 1))
        expect(work_experience_skill).not_to be_valid
        expect(work_experience_skill.errors[:end_date]).to be_present
      end

      it "使用終了日が使用開始日より後の場合、有効" do
        work_experience = create(:work_experience)
        work_experience_skill = build(:work_experience_skill,
                                      work_experience: work_experience,
                                      start_date: Date.new(2022, 1, 1),
                                      end_date: Date.new(2023, 1, 1))
        expect(work_experience_skill).to be_valid
      end
    end
  end
end

