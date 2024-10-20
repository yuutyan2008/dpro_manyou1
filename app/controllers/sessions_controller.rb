class SessionsController < ApplicationController
  # current_user が nil の場合はログイン画面にリダイレクト
  before_action :login_required

  # 以下の場合はbefore_actionの実行をしない
  skip_before_action :login_required, only: %i[new create]
  # ログイン中のユーザーがログインやアカウント登録のページにアクセスしようとした場合redirect_if_logged_inを実行
  before_action :redirect_if_logged_in, only: %i[new create]

  def new
    #セッションに関してはインスタンスの作成が必要ないので、newアクションには何も処理が入りません
    @user = User.new
  end

  # Sessionsコントローラにセッションを作成する
  def create
    puts params[:session][:email]
    #入力されたメールアドレスを元に、find_byメソッドを使ってデータベースからユーザを取り出す
    @user = User.find_by(email: params[:session][:email].downcase)

    # メールアドレスとパスワードの組み合わせが有効か調べる
    # find_byで取得したユーザのパスワードと引数に指定したパスワードが一致するかを検証
    # params[:session][:password]で入力されたパスワードを取得
    # &.を利用し、nilの場合でもエラーが発生しないようにします
    # has_secure_passwordをmodelに定義したことで使えるようになる
    if @user&.authenticate(params[:session][:password])
      # ログイン成功した場合
      #ログインした際は、Flashを表示させる
      flash[:notice] = I18n.t("flash.sessions.create_success")
      # セッションオブジェクトにユーザIDを登録し、そのユーザの詳細画面に遷移
      log_in(@user)
      # URLヘルパーメソッドuser_pathで /tasks (index アクション) にリダイレクトする
      redirect_to tasks_path
    else
      # ログイン失敗した場合
      # renderを使ってnewアクションを呼び出します。
      # 現在のリクエストの間だけメッセージを保持
      flash.now[:danger] = I18n.t("flash.sessions.create_failure")
      render :new
    end
  end

  # Sessionsコントローラにログアウトを行う
  def destroy
    session.delete(:user_id) # セッションオブジェクトからユーザIDを削除

    #ログアウトした際は、ログインページに遷移させ、Flashを表示させる
    flash[:notice] = I18n.t("flash.sessions.destroy")
    redirect_to new_session_path
  end

  private

  def login_required
    unless current_user
      flash[:alert] = "ログインしてください"
      redirect_to login_path
    end
  end

  # ログイン中のユーザーがログインやアカウント登録のページにアクセスしようとした場合、
  # タスク一覧画面にリダイレクトし、フラッシュメッセージを表示する
  def redirect_if_logged_in
    if logged_in?
      flash[:alert] = I18n.t("flash.sessions.logout_required")
      redirect_to tasks_path
    end
  end
end
