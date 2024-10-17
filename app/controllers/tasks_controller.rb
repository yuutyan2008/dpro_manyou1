class TasksController < ApplicationController
  def index
    # 検索パラメータの初期化
    @search_params = search_params
    # 検索機能（スコープを適用）
    @tasks =
      Task
        .all
        .search_by_title(@search_params[:title])
        .search_by_status(@search_params[:status])

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
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t("flash.create.success")
    else
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
    params.fetch(:search, {}).permit(:title, :status)
  end
end
