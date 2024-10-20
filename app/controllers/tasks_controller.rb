class TasksController < ApplicationController
  # controllerのアクション実行前にログインが必要
  before_action :login_required
  # 他人のタスク画面にアクセスしようとした場合、タスク一覧画面に遷移
  before_action :correct_user, only: %i[show edit update destroy]

  # アクション実行前にset_taskが必要なもの。indexは特定の1つのタスクを取得する必要がないため不要
  # editは編集データを取得する必要がある
  before_action :search_params, only: %i[show edit update destroy]

  def index
    # dログインしているユーザーのタスクのみ表示
    @tasks = current_user.tasks
    # 検索パラメータの初期化
    # earch_paramsメソッドで許可した値のみ取得して@search_paramsに格納
    @search_params = search_params
    # 検索機能（スコープを適用）
    @tasks =
      @tasks.search_by_title(@search_params[:title]).search_by_status(
        @search_params[:status]
      )

    # puts @search_params.inspect #コンソールでエラー原因の確認に使用

    if params[:sort_deadline_on].present?
      @tasks = @tasks.sort_by_deadline
      # 終了期限でソート
    elsif params[:sort_priority].present?
      @tasks = @tasks.sort_by_priority
      # 優先度でソート
    else
      @tasks = @tasks.sort_by_created_at
    end

    # ページネーションで1ページあたり10件表示するように設定
    @tasks = @tasks.page(params[:page]).per(10)
  end

  # # クエリをログに出力（確認用）
  # puts @tasks.to_sql

  # render :index

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    # current_userはusercontrollerで設定、ログイン中のuser_idでuser情報を取得
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: t("flash.create.success")
    else
      Rails.logger.info @task.errors.full_messages.to_sentence # エラー内容をログに出力
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t("flash.update.success")
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: t("flash.destroy.success")
  end

  private

  def task_params
    params.require(:task).permit(
      :title,
      :content,
      :deadline_on,
      :priority,
      :status
    )
  end

  # ストロングパラメータの設定
  # このメソッドを追加して、search パラメータ内の title と status だけを許可します。
  def search_params
    # search パラメータが存在することを確認し、その中で title と status だけを許可します。
    # :search パラメータが存在しない場合に、空のハッシュ {} を返す
    params.fetch(:search, {}).permit(:title, :status)
  end

  # 他人のタスク詳細画面や編集画面にアクセスしようとした場合、タスク一覧画面にリダイレクト
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      flash[:alert] = I18n.t("flash.tasks.index")
      redirect_to tasks_path
    end
  end
end
