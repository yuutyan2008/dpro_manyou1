class ApplicationController < ActionController::Base
  #SessionsコントローラでしかSessionsHelper 内のメソッドを呼び出せない
  #すべてのコントローラで利用できるようSessionHelperをインクルード
  include SessionsHelper

  # すべてのコントローラのアクションが実行される前に必ず login_required メソッドが呼び出される
  before_action :login_required

  # ログイン中のユーザーがログインページにアクセスしようとした場合redirect_if_logged_inを実行
  before_action :redirect_if_logged_in, only: %i[new create]

  private # 外部から直接呼び出されないようにする

  # ログインしなければアクセスできないよう制限
  def login_required
    # リダイレクト時にフラッシュメッセージを表示
    unless logged_in?
      flash[:alert] = I18n.t("flash.sessions.login_required")
      # current_userがnilの場合、ログイン画面に遷移させることで、未ログインのユーザからのアクセスを禁止
      redirect_to new_session_path
    end
  end

  # ログイン中のユーザーがログインやアカウント登録のページにアクセスしようとした場合、
  # リダイレクトし、フラッシュメッセージを表示する
  def redirect_if_logged_in
    # ログインページやアカウント登録ページの場合はリダイレクトしない
    if logged_in? &&
         (request.path == new_user_path || request.path == new_session_path)
      flash[:alert] = I18n.t("flash.sessions.logout_required")
      redirect_to tasks_path
    end
  end
end
