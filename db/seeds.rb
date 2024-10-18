# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
#
# 既存のデータを削除
Task.delete_all
User.delete_all

# ユーザーのサンプルデータを作成
5.times do |n|
  User.create!(
    name: "User_#{n + 1}",
    email: "user_#{n + 1}@example.com",
    password_digest: "password",
    password_confirmation: "password",
    admin: false
  )
end

# 管理者ユーザーを追加
User.create!(
  name: "Admin_User",
  email: "admin@example.com",
  password_digest: "adminpassword",
  password_confirmation: "adminpassword",
  admin: true # 管理者ユーザー
)

# 50件のタスクデータを作成
50.times do |n|
  Task.create!(
    title: "Task_#{n + 1}", # タスクのタイトルをTask_1, Task_2, ... のようにする
    content: "This is task number #{n + 1}.", # タスクの内容をシンプルな文にする
    deadline_on: Date.today + rand(1..30).days, # 今日から1日～30日後のランダムな日付を設定
    priority: rand(0..2), # enumに対応するpriorityをランダムに設定 (low: 0, middle: 1, high: 2)
    status: rand(0..2), # enumに対応するstatusをランダムに設定 (not_started: 0, under_way: 1, completed: 2)
    user_id: User.all.sample.id # ランダムなユーザーを関連付ける。sampleはArray クラスのメソッドで、配列からランダムに1つの要素を取得するために使います
  )
end
