class Label < ApplicationRecord
  # 中間テーブルを先に書く
  has_many :tasks_labels
  # その次に多対多の関係先のテーブル
  has_many :tasks, through: :tasks_labels

  validates :name, presence: true
end
