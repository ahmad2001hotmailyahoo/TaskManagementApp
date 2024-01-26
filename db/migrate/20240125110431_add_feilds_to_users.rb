class AddFeildsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :date_of_birth, :string, null: false, default: ""
    add_column :users, :gender, :string, null: false, default: ""
    add_column :users, :name, :string
  end
end
