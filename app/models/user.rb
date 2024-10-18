class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 } #presence: true⇛name属性は必ず入力
  validates :email,
            presence: true,
            length: {
              maximum: 255
            },
            uniqueness: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
            }

  # 大文字と小文字の区別をなくす
  before_validation { email.downcase! }

  # パスワードをハッシュ化
  # has_secure_passwordと書くことでユーザーが新規登録を行う際には password と password_confirmation が必須になります
  # Rails は内部的に password と password_confirmation という仮想的な属性を作成し、これらに対してバリデーションが行われます
  # よってパスワードのvalidationが不要になります
  has_secure_password

  # User モデルと Task モデルの間にアソシエーションを設定
  # ユーザーが削除されると、そのユーザーに関連するタスクも削除
  has_many :tasks, dependent: :destroy

  before_destroy :ensure_an_admin_remains, if: -> { admin? }

  private

  # 管理者が1人しかいない場合、その管理者ユーザを削除できないようにします
  def ensure_an_admin_remains
    if User.where(admin: true).count == 1
      errors.add(:base, "管理者が0人になるため削除できません")
      throw(:abort)
    end
  end
end
