class ApplicationController < ActionController::Base
  #SessionsコントローラでしかSessionsHelper 内のメソッドを呼び出せない
  #すべてのコントローラで利用できるようSessionHelperをインクルード
  include SessionsHelper

  # すべてのコントローラのアクションが実行される前に必ず login_required メソッドが呼び出される
  before_action :login_required

  private # 外部から直接呼び出されないようにする

  # ログインしなければアクセスできないよう制限
  def login_required
    # リダイレクト時にフラッシュメッセージを表示
    unless logged_in?
      flash[:alert] = t("flash.common.login_required")
      # current_userがnilの場合、ログイン画面に遷移させることで、未ログインのユーザからのアクセスを禁止
      redirect_to new_session_path unless current_user
    end
  end
end
