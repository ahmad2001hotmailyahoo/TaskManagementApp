class RemoveFromUsersTables < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :uid, :string
    remove_column :users, :avatar_url, :string
    remove_column :users, :provider, :string
  end
end
