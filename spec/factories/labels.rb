FactoryBot.define do
  factory :label do
    name { "重要" }
  end

  factory :third_task do
    title { "書類作成" }
    content { "企画書を作成する。" }
    deadline_on { "2024-10-16" }
    priority { 1 }
    status { 1 }
    association :user # ユーザーとの関連付け

    # trait は、FactoryBotで特定の条件や追加機能を持たせたい場合に使うメソッド
    # :with_labelsという名前のトレイトを作成
    # このトレイトを使うと、タスクにラベルが関連付けられる
    # FactoryBot.create(:label) でラベルを1つ作成し、そのラベルを task.labels << でタスクに追加
    trait :with_labels do
      after(:build) { |task| task.labels << FactoryBot.create(:label) }
    end
  end
end
