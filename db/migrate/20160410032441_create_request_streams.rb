class CreateRequestStreams < ActiveRecord::Migration
  def change
    create_table :request_streams do |t|
      t.string :title
      t.string :url
      t.datetime :start
      t.string :volunteer

      t.timestamps null: false
    end
  end
end
