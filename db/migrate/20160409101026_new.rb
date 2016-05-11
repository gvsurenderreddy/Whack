class New < ActiveRecord::Migration
  def change
 
	remove_column :users, :nick
	add_column :users, :nick, :string, :unique=>true
  end
end
