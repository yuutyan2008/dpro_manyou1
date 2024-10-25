require "rails_helper"

RSpec.describe "ラベル管理機能", type: :system do
  # let(:user) { FactoryBot.create(:user) }
  describe "登録機能" do
    let(:user) { FactoryBot.create(:user) }
    # 共通処理ではなくdescribe毎に書くことに注意
    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end
    context "ラベルを登録した場合" do
      it "登録したラベルが表示される" do
        visit new_label_path # ラベル作成画面に遷移
        fill_in "label_name", with: "重要" # ラベル名を入力。nameがなかったためid: 'label-name'を使用
        click_button "登録" # 登録ボタンをクリック

        expect(page).to have_content "重要" # 登録したラベルが表示されることを確認
      end
    end
  end

  describe "一覧表示機能" do
    let(:user) { FactoryBot.create(:user) }
    # 共通処理ではなくdescribe毎に書くことに注意
    before do
      visit new_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end
    context "一覧画面に遷移した場合" do
      it "登録済みのラベル一覧が表示される" do
        # ラベルデータを作成
        FactoryBot.create(:label, name: "重要", user: user) # ユーザーを指定
        FactoryBot.create(:label, name: "緊急", user: user) # ユーザーを指定

        visit labels_path # ラベル一覧画面に遷移

        expect(page).to have_content "重要" # ラベル名が表示されているか確認
        expect(page).to have_content "緊急"
      end
    end
  end
end
