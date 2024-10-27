# app/controllers/labels_controller.rb
class LabelsController < ApplicationController
  def index
    @labels = Label.includes(:tasks) # タスクと関連付けられたラベルを取得
  end

  def new
    @label = Label.new
  end

  def create
    # labelテーブルのuser_idは必須のためLabelとuser_idを関連付けて保存
    @label = current_user.labels.build(label_params)
    if @label.save
      flash[:notice] = t("flash.labels.created")
      redirect_to labels_path
    else
      puts @label.errors.full_messages # デバッグ用のエラーメッセージ表示
      render :new
    end
  end

  def edit
    @label = Label.find(params[:id])
  end

  def update
    @label = Label.find(params[:id])
    if @label.update(label_params)
      flash[:notice] = t("flash.labels.updated")
      redirect_to labels_path
    else
      render :edit
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    flash[:notice] = t("flash.labels.destroyed")
    redirect_to labels_path
  end

  private

  # ストロングパラメータという仕組み
  # paramsに入ったフォームの全データのうち、labelモデルのpermit()で指定したカラムのみを取り出す
  def label_params
    params.require(:label).permit(:name)
  end
end
