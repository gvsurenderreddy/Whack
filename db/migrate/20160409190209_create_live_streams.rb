class CreateLiveStreams < ActiveRecord::Migration
  def change
    create_table :live_streams do |t|
      t.string :link
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :user

      t.timestamps null: false
    end
  end
end
