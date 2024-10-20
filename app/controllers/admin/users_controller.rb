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
        flash[:notice] = t("flash.users.create")
        # ユーザ登録に成功した場合の処理、user一覧画面に遷移
        redirect_to users_path(@user.id)
      else
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "ユーザを更新しました"
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      if User.where(admin: true).count > 1 || !@user.admin?
        @user.destroy
        redirect_to admin_users_path, notice: "ユーザを削除しました"
      else
        redirect_to admin_users_path, alert: "管理者が0人になるため削除できません"
      end
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
