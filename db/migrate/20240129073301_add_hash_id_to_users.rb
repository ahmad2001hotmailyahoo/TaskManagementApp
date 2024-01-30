class AddHashIdToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :hash_id, :string
    add_index :users, :hash_id, unique: true
    User.all.each{|m| m.set_hash_id; m.save}
  end

  def down
    remove_column :users, :hash_id, :string
  end
end
