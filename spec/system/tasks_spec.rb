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
        task =
          FactoryBot.create(
            :task,
            title: "書類作成",
            content: "企画書を作成する。",
            deadline_on: Date.today,
            priority: 1,
            status: 1,
            created_at: Time.zone.now
          )
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content "書類作成"
        expect(page).to have_content "企画書を作成する。"
        expect(page).to have_content Date.today
        expect(page).to have_content 1
        expect(page).to have_content 1
        expect(page).to have_content task.created_at.strftime("%H:%M") # strftime("%H:%M")はインスタンスメソッド
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe "一覧表示機能" do
    # 以下の3データは、各テストが実行される前に必ずデータベースに作成されます。
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    # let!はletと違い、定義時に即時評価されるため、複数のテストでテストデータを共有できる
    let!(:task1) do
      FactoryBot.create(
        :task,
        title: "first_task",
        created_at: "2022-02-18",
        deadline_on: "2022-02-20",
        priority: 2,
        status: 0
      )
    end
    let!(:task2) do
      FactoryBot.create(
        :task,
        title: "second_task",
        created_at: "2022-02-17",
        deadline_on: "2022-02-19",
        priority: 1,
        status: 1
      )
    end
    let!(:task3) do
      FactoryBot.create(
        :task,
        title: "third_task",
        created_at: "2022-02-16",
        deadline_on: "2022-02-18",
        priority: 0,
        status: 2
      )
    end

    # 「一覧画面に遷移した場合」や「タスクが作成日時の降順に並んでいる場合」など、contextが実行されるタイミングで、before内のコードが実行される
    before { visit tasks_path }

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content "first_task"
        expect(page).to have_content "second_task"
        expect(page).to have_content "third_task"
        expect(page).to have_content "2022-02-20"
        expect(page).to have_content "2022-02-19"
        expect(page).to have_content "2022-02-18"
      end
    end

    context "新たにタスクを作成した場合" do
      it "新しいタスクが一番上に表示される" do
        # 新しいタスクを作成
        FactoryBot.create(
          :task,
          title: "new_task",
          created_at: Time.zone.now,
          deadline_on: Date.today,
          priority: 2,
          status: 0
        )
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
      FactoryBot.create(
        :task,
        title: "first_task",
        created_at: "2022-02-18",
        deadline_on: "2022-02-20",
        priority: 2,
        status: 0
      )
    end
    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        # タスク詳細画面に遷移
        visit task_path(task)

        # visit（遷移）したpage（この場合、タスク詳細画面）に"first_task"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content "first_task"
        expect(page).to have_content "2022-02-18"
        expect(page).to have_content "2022-02-20"
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end
  describe "ソート機能" do
    let!(:task) do
      FactoryBot.create(
        :task,
        title: "first_task",
        created_at: "2022-02-18",
        deadline_on: "2022-02-20",
        priority: 2,
        status: 0
      )
    end

    before { visit tasks_path }

    context "「終了期限」というリンクをクリックした場合" do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # 終了期限で並び替え
        click_link "終了期限"
        task_deadlines = all(".task-deadline").map(&:text)
        save_and_open_page
        # 取得したタスクの期限が昇順で並んでいるか確認
        expect(task_deadlines).to eq task_deadlines.sort
      end
    end

    context "「優先度」というリンクをクリックした場合" do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        visit tasks_path
        # 優先度で並び替え
        click_link "優先度"
        task_priorities = all(".task-priority").map(&:text)
        # 優先度の高い順に並んでいるか確認
        expect(task_priorities).to eq task_priorities.sort.reverse
      end
    end
  end

  describe "検索機能" do
    let!(:task) do
      FactoryBot.create(
        :task,
        title: "first_task",
        created_at: "2022-02-18",
        deadline_on: "2022-02-20",
        priority: 2,
        status: 0
      )
    end

    context "タイトルであいまい検索をした場合" do
      it "検索ワードを含むタスクのみ表示される" do
        # タイトルで検索
        visit tasks_path # どこの画面をひらくか
        fill_in "search_title", with: "first"
        click_button "検索"
        expect(page).to have_content "first_task"
        expect(page).not_to have_content "second_task"
        expect(page).not_to have_content "third_task"
      end
    end

    context "ステータスで検索した場合" do
      it "検索したステータスに一致するタスクのみ表示される" do
        visit tasks_path
        # ステータスで検索
        select "未着手", from: "search_status"
        click_button "検索"
        expect(page).to have_content "first_task"
        expect(page).not_to have_content "second_task"
        expect(page).not_to have_content "third_task"
      end
    end

    context "タイトルとステータスで検索した場合" do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        visit tasks_path
        # タイトルとステータスで検索
        fill_in "search_title", with: "first"
        select "未着手", from: "search_status"
        click_button "検索"
        expect(page).to have_content "first_task"
        expect(page).not_to have_content "second_task"
        expect(page).not_to have_content "third_task"
      end
    end
  end
end
