class RemoveFromUsershashId < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :hash_id, :string
  end
end
