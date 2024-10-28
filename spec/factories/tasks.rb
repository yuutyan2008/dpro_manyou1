# FactoryBotを使ってタスクのテストデータを作成するためのコード

# 「FactoryBotを使用します」という記述
FactoryBot.define do
  factory :task do
    title { "書類作成" }
    content { "企画書を作成する。" }
    deadline_on { "2024-10-15" }
    priority { 1 }
    status { 1 }

    # association :user # user_idを必ず関連付ける

    # 特定のタスク属性を指定するtrait
    trait :first_task do
      title { "first_task" }
      created_at { "2022-02-18" }
      deadline_on { "2022-02-20" }
      priority { 2 }
      status { 0 }
    end

    trait :second_task do
      title { "second_task" }
      created_at { "2022-02-17" }
      deadline_on { "2022-02-19" }
      priority { 1 }
      status { 1 }
    end

    trait :third_task do
      title { "third_task" }
      created_at { "2022-02-16" }
      deadline_on { "2022-02-18" }
      priority { 0 }
      status { 2 }
    end

    # 多対多の関連付けのため、taskデータ作成時にlabelと紐づける
    trait :with_labels do
      after(:create) do |task|
        task.labels << FactoryBot.create(
          :label,
          name: "重要",
          user_id: task.user_id # ログイン中のuserと紐づいたtaskを登録
        )
      end
    end
  end
end
