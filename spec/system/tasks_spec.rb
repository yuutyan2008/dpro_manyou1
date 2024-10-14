require "rails_helper"

RSpec.describe "タスク管理機能", type: :system do
  describe "登録機能" do
    context "タスクを登録した場合" do
      # itには「期待する動作」について記載
      it "登録したタスクが表示される" do
        # テストケース
        # テストで使用するためのタスクを登録
        # Task.create!(title: "書類作成", content: "企画書を作成する。")
        # FactoryBotを使用することで、より簡潔なコードでテストデータを作成する
        FactoryBot.create(:task, title: "書類作成", created_at: Time.zone.now)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content "書類作成"
        expect(page).to have_content "企画書を作成する。"
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe "一覧表示機能" do
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    # let!はletと違い、定義時に即時評価されるため、複数のテストでテストデータを共有できる
    let!(:task1) do
      FactoryBot.create(:task, title: "first_task", created_at: "2022-02-18")
    end
    let!(:task2) do
      FactoryBot.create(:task, title: "second_task", created_at: "2022-02-17")
    end
    let!(:task3) do
      FactoryBot.create(:task, title: "third_task", created_at: "2022-02-16")
    end

    # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
    before { visit tasks_path }

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content "first_task"
        expect(page).to have_content "second_task"
        expect(page).to have_content "third_task"
      end
    end

    context "新たにタスクを作成した場合" do
      it "新しいタスクが一番上に表示される" do
        # 新しいタスクを作成
        FactoryBot.create(:task, title: "new_task", created_at: Time.zone.now)
        visit tasks_path

        # 一番上に新しいタスクが表示されているか確認
        task_titles = all(".task-title").map(&:text)
        # all:HTMLの中で class="task-title"を持つすべての要素を取得
        # mapデカく要素に対し.text メソッドを呼び出し、各要素のテキスト部分を取得

        expect(task_titles.first).to eq "new_task"
      end
    end
  end

  describe "詳細表示機能" do
    # テストケース
    let(:task) do
      FactoryBot.create(:task, title: "first_task", created_at: "2022-02-18")
    end

    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        # タスク詳細画面に遷移
        visit task_path(task)

        # visit（遷移）したpage（この場合、タスク詳細画面）に"first_task"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content "first_task"
        expect(page).to have_content "2022-02-18"
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end
end
