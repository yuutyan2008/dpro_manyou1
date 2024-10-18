# FactoryBotを使ってタスクのテストデータを作成するためのコード

# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :task do
    title { "書類作成" }
    content { "企画書を作成する。" }
    deadline_on { "2024-10-15" }
    priority { 1 }
    status { 1 }
    association :user # タスクに紐づくユーザを必ず作成する
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { "メール送信" }
    content { "顧客へ営業のメールを送る。" }
    deadline_on { "2024-10-15" }
    priority { 1 }
    status { 1 }
    association :user # タスクに紐づくユーザを必ず作成する
  end
end
