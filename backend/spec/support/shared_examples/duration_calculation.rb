# 期間計算メソッドの共通テスト
# 注意: 期間計算のロジック自体は各モデルに実装されており、共通関数ではありません。
# テストのみを共通化しています。
#
# 使用方法:
#   RSpec.describe SomeModel do
#     it_behaves_like "duration calculation", :duration_months, :duration_years_and_months do
#       let(:subject_with_dates) do
#         build(:model, start_date: Date.new(2020, 1, 1), end_date: Date.new(2023, 1, 1))
#       end
#       let(:subject_without_end_date) do
#         build(:model, start_date: 12.months.ago.to_date, end_date: nil)
#       end
#     end
#   end
RSpec.shared_examples "duration calculation" do |months_method, years_and_months_method|
  describe "##{months_method}" do
    context "終了日が設定されている場合" do
      it "開始日と終了日の間の月数を計算する" do
        result = subject_with_dates.public_send(months_method)
        expect(result).to eq(37) # 36 months + 1
      end
    end

    context "終了日がnilの場合" do
      it "開始日から現在日付までの月数を計算する" do
        result = subject_without_end_date.public_send(months_method)
        expect(result).to be >= 12
      end
    end
  end

  describe "##{years_and_months_method}" do
    it "total_months、years、monthsを返す" do
      result = subject_with_dates.public_send(years_and_months_method)

      expect(result[:total_months]).to eq(37) # 36 months + 1
      expect(result[:years]).to eq(3)
      expect(result[:months]).to eq(1)
    end
  end
end

