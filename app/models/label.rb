class Label < ApplicationRecord
  # 中間テーブルを先に書く
  has_many :tasks_labels, dependent: :destroy
  # その次に多対多の関係先のテーブル
  has_many :tasks, through: :tasks_labels
  # 各ラベルは1人のユーザーに属する
  belongs_to :user
  validates :name, presence: true
end
