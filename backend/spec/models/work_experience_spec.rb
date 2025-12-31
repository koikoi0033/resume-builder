require "rails_helper"

RSpec.describe WorkExperience, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to have_many(:work_experience_skills).dependent(:destroy) }
    it { is_expected.to have_many(:skills).through(:work_experience_skills) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:company_name) }
    it { is_expected.to validate_presence_of(:start_date) }
  end

  describe "scopes" do
    let(:profile) { create(:profile) }

    describe ".ordered" do
      let!(:we1) { create(:work_experience, profile: profile, display_order: 1, start_date: Date.new(2020, 1, 1)) }
      let!(:we2) { create(:work_experience, profile: profile, display_order: 0, start_date: Date.new(2021, 1, 1)) }

      it "表示順序の昇順、その後開始日の降順でソートする" do
        expect(WorkExperience.ordered).to eq([we2, we1])
      end
    end

    describe ".current" do
      let!(:current_we) { create(:work_experience, profile: profile, end_date: nil) }
      let!(:past_we) { create(:work_experience, profile: profile, end_date: Date.new(2023, 1, 1)) }

      it "終了日がnilの職務経歴のみを返す" do
        expect(WorkExperience.current).to include(current_we)
        expect(WorkExperience.current).not_to include(past_we)
      end
    end

    describe ".past" do
      let!(:current_we) { create(:work_experience, profile: profile, end_date: nil) }
      let!(:past_we) { create(:work_experience, profile: profile, end_date: Date.new(2023, 1, 1)) }

      it "終了日が設定されている職務経歴のみを返す" do
        expect(WorkExperience.past).to include(past_we)
        expect(WorkExperience.past).not_to include(current_we)
      end
    end
  end

  describe "#current?" do
    it "終了日がnilの場合、trueを返す" do
      work_experience = build(:work_experience, end_date: nil)
      expect(work_experience.current?).to be true
    end

    it "終了日が設定されている場合、falseを返す" do
      work_experience = build(:work_experience, end_date: Date.new(2023, 1, 1))
      expect(work_experience.current?).to be false
    end
  end

  describe "#duration_months" do
    let(:subject_with_dates) do
      build(:work_experience,
            start_date: Date.new(2020, 1, 1),
            end_date: Date.new(2023, 1, 1))
    end
    let(:subject_without_end_date) do
      build(:work_experience,
            start_date: 12.months.ago.to_date,
            end_date: nil)
    end

    it_behaves_like "duration calculation", :duration_months, :duration_years_and_months
  end

  describe "validations" do
    describe "#end_date_after_start_date" do
      it "終了日が開始日より前の場合、無効" do
        work_experience = build(:work_experience,
                                start_date: Date.new(2023, 1, 1),
                                end_date: Date.new(2022, 1, 1))
        expect(work_experience).not_to be_valid
        expect(work_experience.errors[:end_date]).to be_present
      end

      it "終了日が開始日より後の場合、有効" do
        work_experience = build(:work_experience,
                                start_date: Date.new(2022, 1, 1),
                                end_date: Date.new(2023, 1, 1))
        expect(work_experience).to be_valid
      end
    end

    describe "#dates_within_reasonable_range" do
      it "開始日が未来の場合、無効" do
        work_experience = build(:work_experience,
                                start_date: 1.year.from_now.to_date)
        expect(work_experience).not_to be_valid
        expect(work_experience.errors[:start_date]).to be_present
      end

      it "終了日が未来の場合、無効" do
        work_experience = build(:work_experience,
                                end_date: 1.year.from_now.to_date)
        expect(work_experience).not_to be_valid
        expect(work_experience.errors[:end_date]).to be_present
      end

      it "日付が過去または現在の場合、有効" do
        work_experience = build(:work_experience,
                                start_date: 1.year.ago.to_date,
                                end_date: Date.current)
        expect(work_experience).to be_valid
      end
    end
  end
end

