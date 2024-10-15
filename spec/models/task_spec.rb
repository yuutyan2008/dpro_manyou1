require "rails_helper"

RSpec.describe "タスクモデル機能", type: :model do
  # describeには「どの仕様（機能）についてのテストか」
  describe "バリデーションのテスト" do
    # contextには「状況、状態を分類したテスト内容」
    context "タスクのタイトルが空文字の場合" do
      # itには「期待する動作」について記載
      it "バリデーションに失敗する" do
        # テストケース
        task = Task.create(title: "", content: "企画書を作成する。")
        expect(task).not_to be_valid
      end
    end

    context "タスクの説明が空文字の場合" do
      it "バリデーションに失敗する" do
        # テストケース
        task = Task.create(title: "企画書", content: "")
        expect(task).not_to be_valid
      end
    end

    context "タスクのタイトルと説明に値が入っている場合" do
      it "タスクを登録できる" do
        # テストケース
        task = Task.create(title: "企画書", content: "企画書を作成する。")
        # 条件が成功することを
        expect(task).to be_valid
      end
    end
  end
end
