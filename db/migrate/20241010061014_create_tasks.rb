class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.date :deadline_on, null: false
      t.integer :priority, null: false
      t.integer :status, null: false
      t.timestamps
    end
  end
end
