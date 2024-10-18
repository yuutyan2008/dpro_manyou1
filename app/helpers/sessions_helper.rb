module SessionsHelper
  # 現在ログインしているユーザーを取得
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしているか確認
  def logged_in?
    current_user.present?
  end

    # ユーザーがログイン中のユーザーと一致するか確認
    def current_user?(user)
      user == current_user
    end
  
  # ユーザーがログイン中のユーザーと一致するか確認
  def log_in(user)
    session[:user_id] = user.id
  end
end

