class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :due_date
      t.string :Date
      t.string :status

      t.timestamps
    end
  end
end
