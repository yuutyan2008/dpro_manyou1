Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  # 管理者専用のルーティング
  # :adminという名前空間を作成し、その中の全てのルートは/adminパスがプレフィックスとして追加されます
  namespace :admin do
    resources :users, only: %i[index show new edit create update destroy]
  end

  # 一般user用
  root "tasks#index"
  resources :tasks
  # form_withを使用するためルーティングにcreateアクションを追加
  #  データベースから特定のユーザーの情報を取得して表示するshowアクションを追加
  resources :users, only: %i[new create show edit update destroy]

  # ログイン機能のSessionsコントローラ用のルーティング
  # destroyはSessionsコントローラにログアウトを行うためのdestroyアクション
  resources :sessions, only: %i[new create destroy]
end
