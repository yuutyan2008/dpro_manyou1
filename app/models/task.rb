class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # カラム名priority、定義の内容は低中高
  # enum priority: [:low, :middle, :high]
  enum priority: { low: 0, middle: 1, high: 2 }
  enum status: { not_started: 0, under_way: 1, completed: 2 }

  # 検索用スコープ
  scope :search_by_title,
        ->(title) { where("title LIKE ?", "%#{title}%") if title.present? }
  scope :search_by_status,
        ->(status) { where(status: statuses[status]) if status.present? }

  # ソート用スコープ
  scope :sort_by_deadline, -> { order(deadline_on: :asc, created_at: :desc) }
  scope :sort_by_priority, -> { order(priority: :desc, created_at: :desc) }
  #   scope :sort_by_created_at, -> { order(created_at: :desc) }

  # scopeメソッドの内容はココと同じ意味
  #   def self.search_by_status(status)
  #     where(status: statuses[status]) if status.present?
  #   end
end
