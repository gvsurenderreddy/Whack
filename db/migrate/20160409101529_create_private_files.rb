class CreatePrivateFiles < ActiveRecord::Migration
  def change
    create_table :private_files do |t|
      t.string :user
      t.string :link
      t.string :max_downloads

      t.timestamps null: false
    end
  end
end
