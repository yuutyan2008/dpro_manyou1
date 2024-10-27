class TasksController < ApplicationController
  # controllerのアクション実行前にログインが必要
  before_action :login_required
  # 他人のタスク画面にアクセスしようとした場合、タスク一覧画面に遷移
  before_action :correct_user, only: %i[show edit update destroy]

  # アクション実行前にset_taskが必要なもの。indexは特定の1つのタスクを取得する必要がないため不要
  # editは編集データを取得する必要がある
  before_action :search_params, only: %i[show edit update destroy]

  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_labels, only: %i[index show new create edit update]

  def index
    # @tasks = current_user.tasksで検索対象のデータ全体を取得
    @tasks = current_user.tasks
    # binding.irb
    # 検索パラメータの初期化
    # earch_paramsメソッドで許可した値のみ取得して@search_paramsに格納
    @search_params = search_params

    # 検索の実行（スコープを適用）
    @tasks =
      @tasks
        .search_by_title(@search_params[:title])
        .search_by_status(@search_params[:status])
        .search_by_label(@search_params[:label_id])

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
    # @task = Task.find(params[:id])
    # @labels = current_user.labels # ログイン中のユーザが作成したラベルのみ取得
  end

  def new
    @task = Task.new
    # @labels = current_user.labels # ログイン中のユーザが作成したラベルのみ取得
  end

  def create
    # current_userはusercontrollerで設定、ログイン中のuser_idでuser情報を取得
    @task = current_user.tasks.build(task_params)
    # binding.irb
    if @task.save
      redirect_to tasks_path, notice: t("flash.tasks.created")
    else
      Rails.logger.info @task.errors.full_messages.to_sentence # エラー内容をログに出力
      render :new
    end
  end

  def edit
    # @task = Task.find(params[:id])
    # @labels = current_user.labels # ログイン中のユーザが作成したラベルのみ取得
  end

  def update
    # @task = Task.find(params[:id])
    # @labels = current_user.labels # ログイン中のユーザが作成したラベルのみ取得
    if @task.update(task_params)
      redirect_to task_path(@task), notice: t("flash.tasks.updated")
    else
      render :edit
    end
  end

  def destroy
    # @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: t("flash.tasks.destroyed")
  end

  private

  def task_params
    params.require(:task).permit(
      :title,
      :content,
      :deadline_on,
      :priority,
      :status,
      label_ids: [] # 配列としてlabel_idsを許可
    )
  end

  # ストロングパラメータの設定
  # このメソッドを追加して、search パラメータ内の title と status label_idだけを許可します。
  # def search_params
  #   params.permit(:title, :status, :label_id)
  # end

  def search_params
    params.fetch(:search, {}).permit(:title, :status, :label_id)
  end

  # 他人のタスク詳細画面や編集画面にアクセスしようとした場合、タスク一覧画面にリダイレクト
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      flash[:alert] = I18n.t("flash.admin.index")
      redirect_to tasks_path
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_labels
    @labels = current_user.labels
    # puts "Labels for current user: #{@labels.inspect}" # デバッグ出力
  end
end
