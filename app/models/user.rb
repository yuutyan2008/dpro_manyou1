class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 } #presence: true⇛name属性は必ず入力
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  # 大文字と小文字の区別をなくす
  before_validation { email.downcase! }

  # パスワードをハッシュ化
  # has_secure_passwordと書くことでユーザーが新規登録を行う際には password と password_confirmation が必須になります
  # Rails は内部的に password と password_confirmation という仮想的な属性を作成し、これらに対してバリデーションが行われます
  # よってパスワードのvalidationが不要になります
  # validations: falseでvalidationを無効化
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # パスワードにバリデーションを設定
  # has_secure_password を使用するとpassword という属性はデータベースには存在しませんが、ユーザーが入力したパスワードに対するバリデーションやハッシュ化が password_digest に適用されます。
  # validates :password, length: { minimum: 6 }, allow_nil: true

  # User モデルと Task モデルの間にアソシエーションを設定
  # ユーザーが削除されると、そのユーザーに関連するタスクも削除
  has_many :tasks, dependent: :destroy

  # 管理者が1人しかいない状態でそのユーザを削除できないようにする
  # if: -> { admin? } :管理者 (admin == true) のみで実行
  before_destroy :ensure_an_admin_remains, if: -> { admin? }
  # 管理者が1人しかいない状態で管理者権限を外せないようにする
  before_update :ensure_an_admin_remains_on_update,
                if: -> { admin_changed? && !admin? }

  private

  # 管理者が1人しかいない場合、その管理者ユーザを削除できないようにします
  def ensure_an_admin_remains
    if User.where(admin: true).count == 1
      errors.add(:base, "管理者が0人になるため削除できません")
      throw(:abort) # 削除を中断
    end
  end

  # 管理者が1人しかいない状態で管理者権限を外せないようにする
  def ensure_an_admin_remains_on_update
    if User.where(admin: true).count == 1
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw(:abort) # 更新を中止する
    end
  end
end
