class AddAdminToUser < ActiveRecord::Migration[6.1]
  def change
    # admin という名前の boolean（真偽値）型のカラムを追加
    # default: falseデータベースのカラムにデフォルト値falseを設定するためのオプション
    add_column :users, :admin, :boolean, default: false
  end
end
