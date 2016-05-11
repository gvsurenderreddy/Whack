class CreateShareFiles < ActiveRecord::Migration
  def change
    create_table :share_files do |t|
      t.string :owner
      t.string :shared_to
      t.string :token

      t.timestamps null: false
    end
  end
end
