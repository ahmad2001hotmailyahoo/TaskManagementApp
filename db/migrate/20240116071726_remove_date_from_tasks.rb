class RemoveDateFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :Date, :string
  end
end
