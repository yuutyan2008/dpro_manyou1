require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '登録機能' do
    context 'タスクを登録した場合' do

      # itには「期待する動作」について記載
      it '登録したタスクが表示される' do

        # テストケース
        # テストで使用するためのタスクを登録
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        # FactoryBotを使用することで、より簡潔なコードでテストデータを作成する
        FactoryBot.create(:task, title: '書類作成', content: '企画書を作成する。')
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する。'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        # FactoryBotを使用することで、より簡潔なコードでテストデータを作成する
        FactoryBot.create(:task, title: '書類作成', content: '企画書を作成する。')
        # タスク一覧画面に遷移
        visit tasks_path


        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する。'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do

        # テストケース
        # テストで使用するためのタスクを登録
        # Task.create!(title: '書類作成', FactoryBotを使用することで、より簡潔なコードでテストデータを作成するcontent: '企画書を作成する。')
        # 
        task = FactoryBot.create(:task, title: '書類作成', content: '企画書を作成する。')

        # タスク詳細画面に遷移
        visit task_path(task)


        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する。'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される       
       end
     end
  end
end