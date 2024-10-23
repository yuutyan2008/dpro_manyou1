class UsersController < ApplicationController
  # ユーザーが未ログインの状態でアクセス可能なページを設定
  # ユーザー登録用のnewやcreateアクションではlogin_requiredメソッドが実行されないように設定
  before_action :login_required, except: %i[new create]

  # 指定したアクションが呼ばれた際、correct_userメソッドを先に実行する
  # 管理者はすべての権限がある
  before_action :correct_user,
                only: %i[show edit update destroy],
                unless: -> { current_user.admin? }

  # アカウント登録フォームを表示するための処理
  def new
    #新しいUserモデルのインスタンスを作成し、登録フォームで使用できるようにします。
    @user = User.new
  end

  #
  def create
    @user = User.new(user_params) #登録フォームの入力値を持つインスタンスを作成し、@userに入る
    if @user.save
      # log_in(user)メソッドをユーザが登録された際に呼び出すことで、ログインも同時に行うことができます
      log_in(@user)

      # 国際化（i18n）
      # ja.yml に定義したフラッシュメッセージに翻訳
      flash[:notice] = t("flash.users.create")

      # ユーザ登録に成功した場合の処理、タスク一覧画面に遷移
      redirect_to tasks_path
    else
      puts @user.errors.full_messages # validationメッセージを表示
      # ユーザ登録に失敗した場合の処理:再び登録画面が表示
      render :new
    end
  end

  #パラメータに含まれるidを使ってユーザを特定することで、そのユーザの詳細画面を表示
  def show
    # URLから渡されるidでユーザーを検索し、@userに格納
    @user = User.find(params[:id])
  end
  #登録フォームの入力値は、ストロングパラメータparamsを使って取得

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 国際化（i18n）
      # ja.yml に定義したフラッシュメッセージに翻訳
      flash[:notice] = t("flash.users.update")
      redirect_to user_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      # ココ(削除実行直前)でmodelに定義したコールバックが呼ばれる

      flash[:notice] = t("flash.admin.destroy")
    else
      # バリデーションに失敗で@user.errors.full_messagesにエラーメッセージが配列として追加されます
      # .join(", "): 配列内の全てのエラーメッセージをカンマ区切り（, ）で連結
      flash[:alert] = @user.errors.full_messages.join(", ")
    end
    redirect_to root_path
  end

  private

  # 未ログインのユーザーを制限
  def login_required
    unless current_user
      flash[:notice] = t("flash.sessions.login_required")
      redirect_to new_session_path
    end
  end

  # ストロングパラメータという仕組み
  # paramsに入ったフォームの全データのうち、userモデルのpermit()で指定したカラムのみを取り出す
  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  # ログインしているユーザーがアクセス権限を持っているかどうかを確認するメソッド
  # ログイン済みでも他人のデータにアクセスしようとする不正な行為を防ぎます
  # 管理者が他のユーザーの詳細ページにアクセスできるようにcurrent_user.admin?を追加
  def correct_user
    @user = User.find(params[:id])
    # パラメータのidを使ってデータベースからユーザを取り出し、current_user?メソッドの引数に渡すことで、アクセス先が本人のものか確認しています。
    # アクセスしているユーザーが本人でない場合、タスク一覧画面にリダイレクト
    unless current_user.admin? || current_user?(@user)
      flash[:notice] = t("flash.admin.index")
      redirect_to tasks_path
    end
  end
end
