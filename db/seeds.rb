# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# 50件のタスクデータを作成
50.times do |n|
  Task.create!(
    title: "Task_#{n + 1}", # タスクのタイトルをTask_1, Task_2, ... のようにする
    content: "This is task number #{n + 1}." # タスクの内容をシンプルな文にする
  )
end
