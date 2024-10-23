# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User_#{n}" } # ユーザ名を連番で作成
    sequence(:email) { |n| "user_#{n}@example.com" } # メールアドレスを連番で作成
    password { "password" }
    password_confirmation { "password" }
    admin { false }

    # 管理者ユーザ用のfactoryも定義
    trait :admin do
      admin { true }
    end
  end
end
