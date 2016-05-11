class Editmaxd < ActiveRecord::Migration
  def change
 
  remove_column :private_files, :max_downloads
  add_column :private_files, :max_downloads , :integer 
 end
end
