module Admin
  class UsersController < ApplicationController
    #管理者しか管理者画面にアクセスできないようにする
    before_action :admin_user

    def index
      # ユーザーデータを取得する際に、そのユーザーに関連するタスクも一緒にロードします。
      # これにより、個々のユーザーごとにタスクの数を取得するための追加クエリが発生せず、N+1問題を回避できます。
      @users = User.includes(:tasks) # ユーザとその関連するタスクを同時にロードする
    end

    def show
      @user = User.find(params[:id])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        # 国際化（i18n）
        # ja.yml に定義したフラッシュメッセージに翻訳
        flash[:notice] = t("flash.admin.create")
        # ユーザ登録に成功した場合の処理、user一覧画面に遷移
        redirect_to admin_users_path
      else
        render :new
      end
    end

    # def edit
    #   @user = User.find(params[:id])
    # end
    def edit
      @user = User.find_by(id: params[:id])
      if @user.nil?
        Rails.logger.debug "ユーザーが見つかりません"
        # もしくは以下のコードで例外を投げる
        raise "ユーザーが見つかりません"
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        # 国際化（i18n）
        # ja.yml に定義したフラッシュメッセージに翻訳
        # binding.irb
        flash[:notice] = t("flash.admin.update")
        # binding.irb

        redirect_to admin_users_path
      else
        flash.now[:alert] = @user.errors.full_messages.join(", ") # エラーメッセージを追加
        render :edit
      end
    end

    # 管理者削除を防ぐロジックはmodelに記載
    def destroy
      @user = User.find(params[:id])
      if User.where(admin: true).count > 1 || !@user.admin?
        @user.destroy

        # 国際化（i18n）
        # ja.yml に定義したフラッシュメッセージに翻訳

        flash[:notice] = t("flash.admin.destroy")
      else
        # バリデーションに失敗で@user.errors.full_messagesにエラーメッセージが配列として追加されます
        # .join(", "): 配列内の全てのエラーメッセージをカンマ区切り（, ）で連結
        flash[:alert] = @user.errors.full_messages.join(", ")
      end
      redirect_to admin_users_path
    end

    private

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :admin
      )
    end

    # 一般ユーザがアクセスした場合にはタスク一覧画面にリダイレクト
    def admin_user
      unless current_user&.admin?
        redirect_to tasks_path, alert: "管理者以外アクセスできません"
      end
    end
  end
end
