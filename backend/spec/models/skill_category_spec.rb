require "rails_helper"

RSpec.describe SkillCategory, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:skills).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:display_order) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe "scopes" do
    let!(:active_category) { create(:skill_category, is_active: true) }
    let!(:inactive_category) { create(:skill_category, is_active: false) }

    describe ".active" do
      it "有効なカテゴリのみを返す" do
        expect(SkillCategory.active).to include(active_category)
        expect(SkillCategory.active).not_to include(inactive_category)
      end
    end

    describe ".ordered" do
      let!(:category1) { create(:skill_category, display_order: 2) }
      let!(:category2) { create(:skill_category, display_order: 1) }

      it "表示順序の昇順でソートする" do
        expect(SkillCategory.ordered).to eq([category2, category1])
      end
    end
  end

  describe ".find_by_code" do
    let!(:category) { create(:skill_category, code: "programming_language") }

    it "コードからカテゴリを取得する" do
      expect(SkillCategory.find_by_code("programming_language")).to eq(category)
    end

    it "存在しないコードの場合、nilを返す" do
      expect(SkillCategory.find_by_code("nonexistent")).to be_nil
    end
  end

  describe "dependent: :restrict_with_error" do
    let!(:category) { create(:skill_category) }
    let!(:skill) { create(:skill, skill_category: category) }

    it "スキルが存在する場合、カテゴリを削除できない" do
      expect { category.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end

    it "スキルが存在しない場合、カテゴリを削除できる" do
      skill.destroy
      expect { category.destroy }.not_to raise_error
    end
  end
end

