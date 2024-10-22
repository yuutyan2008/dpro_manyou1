require "rails_helper"

RSpec.describe "ユーザ管理機能", type: :system do
  describe "登録機能" do
    context "ユーザを登録した場合" do
      it "タスク一覧画面に遷移する" do
        visit new_user_path
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "password"
        fill_in "Password confirmation", with: "password"
        click_button "登録する"
        expect(page).to have_content("タスク一覧ページ")
      end
    end
    context "ログインせずにタスク一覧画面に遷移した場合" do
      it "ログイン画面に遷移し、「ログインしてください」というメッセージが表示される" do
        visit tasks_path
        expect(current_path).to eq(new_session_path)
        expect(page).to have_content("ログインしてください")
      end
    end
  end

  describe "ログイン機能" do
    context "登録済みのユーザでログインした場合" do
      it "タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される" do
      end
      it "自分の詳細画面にアクセスできる" do
      end
      it "他人の詳細画面にアクセスすると、タスク一覧画面に遷移する" do
      end
      it "ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される" do
      end
    end
  end

  describe "管理者機能" do
    context "管理者がログインした場合" do
      it "ユーザ一覧画面にアクセスできる" do
      end
      it "管理者を登録できる" do
      end
      it "ユーザ詳細画面にアクセスできる" do
      end
      it "ユーザ編集画面から、自分以外のユーザを編集できる" do
      end
      it "ユーザを削除できる" do
      end
    end
    context "一般ユーザがユーザ一覧画面にアクセスした場合" do
      it "タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される" do
      end
    end
  end
end
