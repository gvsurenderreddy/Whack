class Addnewtoken < ActiveRecord::Migration
  def change
 
  add_column :private_files, :token , :string
  add_column :videos, :token, :string
  

  end
end
