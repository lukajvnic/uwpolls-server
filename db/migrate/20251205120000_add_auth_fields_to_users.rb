class AddAuthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :google_id, :string
    
    remove_column :users, :name
    
    change_column_null :users, :email, false
    add_index :users, :email, unique: true
    add_index :users, :google_id, unique: true
  end
end
