class TasksLabel < ApplicationRecord
  # joinテーブル自体は独立して機能しないためhas_many :throughを使用しない
  belongs_to :task
  belongs_to :label
end
