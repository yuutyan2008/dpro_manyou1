require "rails_helper"

RSpec.describe "タスクモデル機能", type: :model do
  # describeには「どの仕様（機能）についてのテストか」
  describe "バリデーションのテスト" do
    # contextには「状況、状態を分類したテスト内容」
    context "タスクのタイトルが空文字の場合" do
      # itには「期待する動作」について記載
      it "バリデーションに失敗する" do
        # テストケース
        task =
          Task.create(
            title: "",
            content: "企画書を作成する。",
            deadline_on: Date.today,
            priority: 1,
            status: 1
          )
        expect(task).not_to be_valid
      end
    end

    context "タスクの説明が空文字の場合" do
      it "バリデーションに失敗する" do
        # テストケース
        task =
          Task.create(
            title: "企画書",
            content: "",
            deadline_on: Date.today,
            priority: 1,
            status: 1
          )
        expect(task).not_to be_valid
      end
    end
    # タスクの期限が空の場合
    context "タスクの期限が空の場合" do
      it "バリデーションに失敗する" do
        task =
          Task.create(
            title: "企画書",
            content: "企画書を作成する。",
            deadline_on: nil,
            priority: 1,
            status: 1
          )
        expect(task).not_to be_valid
      end
    end

    # タスクの優先度が空の場合
    context "タスクの優先度が空の場合" do
      it "バリデーションに失敗する" do
        task =
          Task.create(
            title: "企画書",
            content: "企画書を作成する。",
            deadline_on: Date.today,
            priority: nil,
            status: 1
          )
        expect(task).not_to be_valid
      end
    end

    # タスクのステータスが空の場合
    context "タスクのステータスが空の場合" do
      it "バリデーションに失敗する" do
        task =
          Task.create(
            title: "企画書",
            content: "企画書を作成する。",
            deadline_on: Date.today,
            priority: 1,
            status: nil
          )
        expect(task).not_to be_valid
      end
    end

    # タスクのタイトル、説明、期限、優先度、ステータスが全て正しい場合
    context "全ての属性が正しい場合" do
      it "タスクを登録できる" do
        task =
          Task.create(
            title: "企画書",
            content: "企画書を作成する。",
            deadline_on: Date.today,
            priority: 1,
            status: 1
          )
        expect(task).to be_valid
      end
    end
  end

  # 万葉課題3
  describe "検索機能" do
    # テストデータを作成
    let!(:first_task) do
      FactoryBot.create(:task, title: "first_task_title", status: :not_started)
    end
    let!(:second_task) do
      FactoryBot.create(:task, title: "second_task_title", status: :under_way)
    end
    let!(:third_task) do
      FactoryBot.create(:task, title: "third_task_title", status: :completed)
    end

    context "scopeメソッドでタイトルのあいまい検索をした場合" do
      it "検索ワードを含むタスクが絞り込まれる" do
        expect(Task.search_by_title("first")).to include(first_task)
        expect(Task.search_by_title("first")).not_to include(second_task)
        expect(Task.search_by_title("first")).not_to include(third_task)
        expect(Task.search_by_title("first").count).to eq 1
      end
    end

    context "scopeメソッドでステータス検索をした場合" do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_by_status("not_started")).to include(first_task)
        expect(Task.search_by_status("not_started")).not_to include(second_task)
        expect(Task.search_by_status("not_started")).not_to include(third_task)
        expect(Task.search_by_status("not_started").count).to eq 1
      end
    end

    context "scopeメソッドでタイトルのあいまい検索とステータス検索をした場合" do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        binding.irb

        expect(
          Task.search_by_title("first").search_by_status("not_started")
        ).to include(first_task)
        expect(
          Task.search_by_title("first").search_by_status("not_started")
        ).not_to include(second_task)
        expect(
          Task.search_by_title("first").search_by_status("not_started")
        ).not_to include(third_task)
        expect(
          Task.search_by_title("first").search_by_status("not_started").count
        ).to eq 1
      end
    end
  end
end
