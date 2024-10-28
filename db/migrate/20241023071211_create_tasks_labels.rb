class CreateTasksLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks_labels do |t|
      t.references :task, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
    # ユニーク制約を追加して、同じタスクに同じラベルを2回以上付けられないようにする
    add_index :tasks_labels, %i[task_id label_id], unique: true
  end
end
