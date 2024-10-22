require "rails_helper"

RSpec.describe "ユーザ管理機能", type: :system do
  before(:each) { User.destroy_all }
  let!(:user) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  # 管理者ユーザを作成
  let!(:admin2) { FactoryBot.create(:user, :admin) } # 管理者削除をテストするために必要

  describe "登録機能" do
    context "ユーザを登録した場合" do
      it "タスク一覧画面に遷移する" do
        visit new_user_path
        # fill_inには<input ~ name="">のnameのブラウザで表示されている値をいれる
        fill_in "名前", with: "Test User" # 実際のフォームのラベルが「名前」
        fill_in "メールアドレス", with: "test@example.com" # ラベルが「メールアドレス」
        fill_in "パスワード", with: "password" # ラベルが「パスワード」
        fill_in "パスワード（確認）", with: "password" # ラベルが「パスワード確認」
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
    # login_userという変数を定義。{ user }は変数の中身
    let(:login_user) { user }
    # 共通のログイン処理
    # userオブジェクトのemailとpasswordを使ってログイン処理を行う
    before do
      visit new_session_path
      fill_in "メールアドレス", with: login_user.email
      fill_in "パスワード", with: login_user.password
      click_button "ログイン"
    end
    context "登録済みのユーザでログインした場合" do
      it "タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される" do
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content("ログインしました")
      end

      it "自分の詳細画面にアクセスできる" do
        visit user_path(user)
        expect(page).to have_content(user.name)
      end

      it "他人の詳細画面にアクセスすると、タスク一覧画面に遷移する" do
        # log_in_as(user)
        visit user_path(user2)
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content("アクセス権限がありません")
      end

      it "ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される" do
        # log_in_as(user)
        click_link "ログアウト"
        expect(page).to have_current_path(new_session_path)
        expect(page).to have_content("ログアウトしました")
      end
    end
  end

  describe "管理者機能" do
    # login_userという変数を定義。{ admin }は変数の中身
    let(:login_user) { admin }

    # 共通のログイン処理
    # login_userオブジェクトのemailとpasswordを使ってログイン処理を行う
    before do
      visit new_session_path
      fill_in "メールアドレス", with: login_user.email
      fill_in "パスワード", with: login_user.password
      click_button "ログイン"
    end
    context "管理者がログインした場合" do
      it "ユーザ一覧画面にアクセスできる" do
        # log_in_as(admin)
        visit admin_users_path
        expect(page).to have_content("ユーザ一覧ページ")
      end

      it "管理者を登録できる" do
        # log_in_as(admin)
        visit new_admin_user_path
        fill_in "名前", with: "Admin User"
        fill_in "メールアドレス", with: "admin@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
        click_button "登録する"
        expect(page).to have_content("ユーザ一覧ページ")
      end

      it "ユーザ詳細画面にアクセスできる" do
        # log_in_as(admin)
        visit admin_user_path(user)
        expect(page).to have_content(user.name)
      end

      it "管理者は他人の詳細画面にアクセスできる" do
        # log_in_as(admin) # 管理者でログイン
        visit user_path(user) # 他のユーザーの詳細画面にアクセス
        expect(page).to have_content(user.name) # 他のユーザーの情報が表示されることを確認
      end

      it "ユーザ編集画面から、自分以外のユーザを編集できる" do
        # log_in_as(admin1)
        # 管理者が2人いることを確認
        expect(User.where(admin: true).count).to eq(2)

        visit edit_admin_user_path(admin2)
        fill_in "名前", with: "Updated User"
        # binding.irb
        fill_in "メールアドレス", with: "admin2@example.com" # 編集対象のユーザ情報を使用
        fill_in "パスワード", with: "password" # 任意のパスワードを入力
        fill_in "パスワード（確認）", with: "password"
        click_button "更新する"

        # binding.irb
        expect(page).to have_content("ユーザを更新しました")
      end

      it "ユーザを削除できる" do
        # id = destroy-userを指定
        visit admin_users_path

        # 削除ボタンをクリックする前に確認ダイアログが表示される
        page.accept_confirm do
          # ユニークなIDで削除ボタンを見つけてクリック
          find("#destroy-user-#{user.id}").click
        end
        # 削除後のページで、削除が成功したことを示すメッセージが表示されているか確認
        expect(page).to have_content("ユーザを削除しました")

        # ユーザ一覧から削除されたことを確認
        expect(User.where(id: user.id)).not_to exist
      end
    end

    context "一般ユーザがユーザ一覧画面にアクセスした場合" do
      let(:login_user) { user }
      it "タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される" do
        # log_in_as(user)
        visit admin_users_path
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content("管理者以外アクセスできません")
      end
    end
  end
end
