class ApplicationController < ActionController::Base
  #SessionsコントローラでしかSessionsHelper 内のメソッドを呼び出せない
  #すべてのコントローラで利用できるようSessionHelperをインクルード
  include SessionsHelper

  # すべてのコントローラのアクションが実行される前に必ず login_required メソッドが呼び出される
  before_action :login_required

  # ログイン中のユーザーがログインページにアクセスしようとした場合redirect_if_logged_inを実行
  before_action :redirect_if_logged_in, only: %i[new create]

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

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

  # エラーページ
  unless Rails.env.development?
    rescue_from Exception, with: :_render_500
    rescue_from ActiveRecord::RecordNotFound, with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def _render_404(e = nil)
    logger.info "Rendering 404 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: { error: "404 Not Found" }, status: :not_found
    else
      render "errors/404.html", status: :not_found
    end
  end

  def _render_500(e = nil)
    logger.error "Rendering 500 with excaption: #{e.message}" if e

    if request.format.to_sym == :json
      render json: {
               error: "500 Internal Server Error"
             },
             status: :internal_server_error
    else
      render "errors/500.html", status: :internal_server_error
    end
  end
end
