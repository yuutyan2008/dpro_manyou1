require "rails_helper"

RSpec.describe "ラベルモデル機能", type: :model do
  let(:user) { FactoryBot.create(:user) }
  # let(:label) { FactoryBot.build(:label) }
  describe "バリデーションのテスト" do
    context "ラベルの名前が空文字の場合" do
      it "バリデーションに失敗する" do
        label = Label.new(name: "")
        expect(label).not_to be_valid
        expect(label.errors[:name]).to include("を入力してください")
      end
    end

    context "ラベルの名前に値があった場合" do
      it "バリデーションに成功する" do
        #user = FactoryBot.create(:user)
        label = Label.new(name: "重要", user_id: user.id)

        expect(label).to be_valid
      end
    end
  end
end
